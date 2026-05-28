# 前端开发者做 Agent：别只会执行，用 4 类失败策略让 AI 知道怎么停

> 原文链接：https://juejin.cn/post/7635102638107246630
> 文章时间：未标注

## 重点内容与核心观点

文章强调可靠 Agent 的关键不是“能执行”，而是失败后知道如何处理。它将失败分为可重试、可降级、需暂停确认、必须停止等类型，并主张每个工具调用都要返回结构化错误、限制重试次数、记录过程、在最终答案中说明成功与失败。核心观点是，Agent 进入真实业务前必须具备失败分类、降级、暂停、停止和可观测能力，否则越能自动执行，风险越高。

[漫游的渔夫](https://juejin.cn/user/78820569778664/posts)

2026-05-02

335

阅读10分钟

专栏：

从 DOM 到 Prompt：前端开发者的 AI 转型日记

关注

> **作者：前端转 AI 深度实践者**
>
> **【省流助手/核心观点】**：Agent 做 demo 时，最显眼的是“它会调用工具”。但进入真实工程后，更关键的是“工具失败时它怎么办”。可靠的 Agent 必须区分错误类型：超时可以重试，空结果可以降级，权限不足要停止，高风险操作要等待确认。Agent 的成熟度，不取决于它能跑多远，而取决于它在出错时有没有刹车、有没有解释、有没有边界。

* * *

前面几篇，我们已经把 Agent 的核心骨架搭起来了。

- 第 23 篇：Tool Calling，让模型学会调用工具。
- 第 24 篇：工具 Schema，让工具有参数规则和风险边界。
- 第 25 篇：Agent Loop，让模型和工具形成闭环。
- 第 26 篇：Plan-Act-Observe，让 Agent 能处理多步任务。

这一路下来，Agent 看起来越来越像一个能做事的系统。

但还有一个问题必须正面面对：

**如果某一步失败了，Agent 该怎么办？**

这个问题比“怎么调用工具”更接近真实工程。

因为 demo 里的工具通常都成功。

真实世界里的工具不一定。

## 1\. 痛点：会执行不难，失败后不乱跑才难

想象一个任务：

```text

text
 体验AI代码助手
 代码解读
复制代码

帮我查一下订单 A1001 的物流，如果还没送达，再查延迟补偿政策。
```

一个理想流程是：

```text

text
 体验AI代码助手
 代码解读
复制代码

查订单
-> 判断是否送达
-> 查政策
-> 给出建议
```

但真实执行时可能发生很多事：

- 订单接口超时。
- 订单不存在。
- 用户没有权限查这个订单。
- 政策搜索没有结果。
- 工具参数缺失。
- 高风险工具需要用户确认。

如果 Agent 没有失败策略，它可能会做出很糟糕的行为：

- 接口超时后直接放弃。
- 订单不存在还继续查政策。
- 权限不足却假装查到了。
- 政策为空却编一个政策。
- 连续重试同一步，卡到超时。

所以 Agent 真正难的不是“能不能执行”，而是失败时知道该怎么办。

## 2\. 错误做法：把所有失败都当成普通异常

很多初版系统喜欢这样返回：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

type BadToolResult = {
  ok: false;
  error: string;
};
```

比如：

```json

json
 体验AI代码助手
 代码解读
复制代码

{
  "ok": false,
  "error": "执行失败"
}
```

这当然比程序直接崩掉好，但对 Agent 没什么帮助。

因为它不知道下一步应该做什么。

更危险的是，很多系统会写出这种“无脑继续”的逻辑：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

async function unsafeContinue(plan: PlanStep[]) {
  for (const step of plan) {
    const result = await act(step);
    step.observation = result;
  }

  return generateFinalAnswer(plan);
}
```

这段代码的问题是：不管工具成功还是失败，后续步骤都继续执行。

如果查订单失败了，还继续查补偿政策；如果权限不足，还继续生成完整答案。用户看到的结果很顺，但可信度已经坏了。

## 3\. 正确做法：给失败分类，再映射处理策略

先把错误类型结构化。

```ts

ts
 体验AI代码助手
 代码解读
复制代码

type ToolErrorType =
  | "invalid_arguments"
  | "unknown_tool"
  | "not_found"
  | "timeout"
  | "permission_denied"
  | "confirmation_required"
  | "empty_result";

type ToolResult =
  | {
      ok: true;
      data: unknown;
    }
  | {
      ok: false;
      errorType: ToolErrorType;
      message: string;
    };
```

每一种错误的含义都不同：

- `timeout`：可能只是网络抖动。
- `invalid_arguments`：模型或程序传参错了。
- `not_found`：目标资源不存在。
- `permission_denied`：用户没有权限。
- `confirmation_required`：动作有风险，需要用户确认。
- `empty_result`：查询成功了，但没有找到内容。

错误类型越清楚，Agent 越能做正确决策。

接着设计处理策略：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

type FailureDecision =
  | "retry"
  | "fallback"
  | "pause"
  | "stop";

const failureStrategies: Record<ToolErrorType, FailureDecision> = {
  timeout: "retry",
  empty_result: "fallback",
  not_found: "stop",
  invalid_arguments: "stop",
  unknown_tool: "stop",
  permission_denied: "stop",
  confirmation_required: "pause"
};
```

这张表非常朴素，但非常有用。

它把“失败了怎么办”从一句模糊的话，变成了明确工程策略。

## 4\. 重试要克制，不要把 retry 当万能药

看到失败，很多人的第一反应是：

```text

text
 体验AI代码助手
 代码解读
复制代码

那就重试。
```

重试确实有用，但不能滥用。

比如接口超时，可以重试。

但下面这些错误，重试通常没有意义：

- 工具不存在。
- 参数缺失。
- 用户没权限。
- 订单不存在。

所以每个步骤都应该有重试计数：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

type PlanStep = {
  id: string;
  goal: string;
  toolName: string;
  args: Record<string, unknown>;
  status:
    | "pending"
    | "running"
    | "done"
    | "failed"
    | "paused"
    | "fallback";
  retryCount: number;
  maxRetries: number;
  observation?: unknown;
  error?: ToolResult;
  fallbackReason?: string;
};
```

重试判断可以这样写：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

function canRetry(step: PlanStep, result: ToolResult) {
  return (
    !result.ok &&
    result.errorType === "timeout" &&
    step.retryCount < step.maxRetries
  );
}
```

没有上限的重试，不叫韧性，叫迷路。

## 5\. 降级不是糊弄用户，而是诚实表达边界

还有一种失败很常见：空结果。

比如政策搜索工具返回：

```json

json
 体验AI代码助手
 代码解读
复制代码

{
  "ok": false,
  "errorType": "empty_result",
  "message": "没有找到相关政策"
}
```

这时候不一定要让整个任务失败。

Agent 可以降级回答：

```text

text
 体验AI代码助手
 代码解读
复制代码

我查到了订单 A1001 当前仍在运输中，但没有找到明确的延迟补偿政策。建议你联系人工客服确认是否可申请补偿。
```

这就是降级。

降级不是假装成功。

降级是：

- 告诉用户哪些信息查到了。
- 告诉用户哪些信息没查到。
- 不编造不存在的依据。
- 给出下一步建议。

这比“为了完整而胡编”可靠得多。

## 6\. 暂停也是一种能力

有些操作不能失败后直接结束，也不能自动继续。

例如：

```text

text
 体验AI代码助手
 代码解读
复制代码

帮我直接取消这个订单。
```

取消订单是有副作用的高风险操作。

即使模型判断要调用 `cancelOrder`，程序也应该返回：

```json

json
 体验AI代码助手
 代码解读
复制代码

{
  "ok": false,
  "errorType": "confirmation_required",
  "message": "取消订单需要用户确认。"
}
```

这时候 Agent 的正确行为不是继续执行，而是暂停：

```text

text
 体验AI代码助手
 代码解读
复制代码

这个操作会取消订单 A1001。请确认是否继续。
```

暂停不是不智能。

暂停是安全边界的一部分。

一个系统如果不知道什么时候停下来问用户，就不适合处理真实业务。

## 7\. 把失败处理接进 Plan-Act-Observe

第 26 篇我们有：

```text

text
 体验AI代码助手
 代码解读
复制代码

Plan -> Act -> Observe
```

现在加上失败策略：

```text

text
 体验AI代码助手
 代码解读
复制代码

Plan
-> Act
-> 如果成功：Observe Success
-> 如果失败：Handle Failure
-> Retry / Fallback / Pause / Stop
```

核心代码可以这样写：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

function handleStepFailure(step: PlanStep, result: ToolResult) {
  if (result.ok) return "none";

  const decision = failureStrategies[result.errorType];

  if (decision === "retry" && canRetry(step, result)) {
    step.retryCount += 1;
    step.status = "pending";
    step.error = result;
    return "retry";
  }

  if (decision === "fallback") {
    step.status = "fallback";
    step.fallbackReason = result.message;
    step.error = result;
    return "fallback";
  }

  if (decision === "pause") {
    step.status = "paused";
    step.error = result;
    return "pause";
  }

  step.status = "failed";
  step.error = result;
  return "stop";
}
```

再把它接进执行循环：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

async function runStepWithFailureControl(step: PlanStep) {
  step.status = "running";

  const result = await act(step);

  if (result.ok) {
    step.status = "done";
    step.observation = result.data;
    return "continue";
  }

  const decision = handleStepFailure(step, result);

  if (decision === "retry") {
    return "retry";
  }

  if (decision === "fallback") {
    return "continue";
  }

  if (decision === "pause") {
    return "pause";
  }

  return "stop";
}
```

这让 Agent 多了一套刹车系统。

它不再是“计划里有几步就硬跑几步”，而是会根据错误类型做不同处理。

## 8\. 最终答案必须解释失败

失败处理还有一个关键点：最终答案不能只说“失败了”。

它应该说明：

- 哪些步骤成功了。
- 哪些步骤失败了。
- 失败原因是什么。
- 是否重试过。
- 是否降级了。
- 用户下一步可以做什么。

可以从 plan 里生成一个更清楚的回答：

```ts

ts
 体验AI代码助手
 代码解读
复制代码

function summarizePlan(plan: PlanStep[]) {
  const done = plan.filter((step) => step.status === "done");
  const failed = plan.filter((step) => step.status === "failed");
  const fallback = plan.filter((step) => step.status === "fallback");
  const paused = plan.filter((step) => step.status === "paused");

  return {
    done: done.map((step) => step.goal),
    failed: failed.map((step) => ({
      goal: step.goal,
      reason: step.error && !step.error.ok ? step.error.message : "未知错误"
    })),
    fallback: fallback.map((step) => ({
      goal: step.goal,
      reason: step.fallbackReason
    })),
    paused: paused.map((step) => ({
      goal: step.goal,
      reason: step.error && !step.error.ok ? step.error.message : "等待确认"
    }))
  };
}
```

用户侧表达可以是：

```text

text
 体验AI代码助手
 代码解读
复制代码

我查到了订单 A1001 当前仍在运输中。
但在查询延迟补偿政策时没有找到明确结果，因此不能确认是否可自动申请补偿。
建议你联系人工客服，并提供订单号 A1001 进一步确认。
```

这类回答虽然不“全能”，但可信。

AI 产品最怕的不是说“我不知道”。

最怕的是不知道还装知道。

## 9\. 前端开发者怎么理解失败处理

前端其实非常懂失败处理。

你写页面时不会只写成功态。

你还会考虑：

- loading。
- empty。
- error。
- disabled。
- retry。
- permission denied。
- confirm modal。

Agent 也是一样。

工具调用的失败态，就是 AI 系统里的 error state。

高风险确认，就是 AI 系统里的 confirm modal。

空结果降级，就是 AI 系统里的 empty state。

重试上限，就是 AI 系统里的防抖和保护阈值。

所以前端经验在这里非常有价值。

你不是从零开始学 Agent。

你是在把已有的工程直觉迁移到 AI 系统里。

## 10\. 生产环境避坑指南

### 1\. 只重试临时性错误

适合重试的通常是 `timeout`、临时网络错误、上游服务短暂不可用。

不适合重试的是 `invalid_arguments`、`permission_denied`、`not_found`、`unknown_tool`。

### 2\. 重试必须有上限和间隔

每一步都要有 `retryCount` 和 `maxRetries`。

更进一步，可以加指数退避，避免把上游服务打爆。

### 3\. fallback 不能伪装成成功

降级回答必须告诉用户哪些信息拿到了，哪些信息没拿到。

不要把空结果包装成确定结论。

### 4\. pause 必须能恢复

如果高风险操作进入 `paused`，前端要能保存当前 plan，并在用户确认后从暂停步骤继续。

不要让用户确认之后系统重新从第一步跑一遍。

### 5\. 失败要进日志和评测集

每次失败都应该记录：

- `traceId`
- step id
- tool name
- errorType
- retryCount
- final decision

高频失败样本应该回流到测试用例或 Agent 评测集。

## 11\. 常见误区

### 误区 1：失败了就让模型再试一次

不对。模型重试不是万能药。只有临时性错误才适合重试。

### 误区 2：降级就是糊弄用户

不是。好的降级是透明说明边界，不编造结果，并给出下一步建议。

### 误区 3：工具失败了也让 Agent 继续跑完整计划

危险。关键步骤失败时应该停止或暂停，而不是继续生成看似完整的答案。

### 误区 4：错误信息写给开发者看就行

不够。内部错误要结构化，用户侧表达要清楚、克制、可行动。

## 12\. 给前端开发者的落地清单

如果你在团队里做 Agent 失败处理，可以从这份清单开始：

01. 所有工具失败都必须返回 `errorType`。
02. 错误类型要能映射到处理策略。
03. 只有临时性错误才允许重试。
04. 每一步都要有 `retryCount` 和 `maxRetries`。
05. 高风险工具必须支持暂停确认。
06. 空结果可以降级，但不能假装成功。
07. 关键步骤失败后不要继续硬跑。
08. 最终答案要说明成功、失败、跳过和下一步建议。
09. 执行日志要记录每次重试。
10. 测试用例必须覆盖成功、重试、降级、暂停、停止。

这份清单不华丽，但很保命。

Agent 越像能办事的系统，越要认真处理失败。

## 结语

Agent 真正难的，不是会执行。

真正难的是失败后不乱执行。

它要知道什么时候重试，什么时候降级，什么时候暂停，什么时候停止。

这听起来没有“自主智能体”那么炫，但它决定了系统能不能进入真实业务。

一个可靠的 Agent，不是永远顺利地跑到终点。

一个可靠的 Agent，是遇到坑时不会假装没看见，而是踩刹车、留痕迹、说清楚，然后给用户一个可信的下一步。
