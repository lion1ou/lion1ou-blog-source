# Claude Code长期记忆：优雅的上下文管理

> 原文链接：https://mp.weixin.qq.com/s/SAHwfycPMZ5cU9PIXKKlow
> 文章时间：2025年8月3日 07:52

## 重点内容与核心观点

对于任何一个与大型语言模型（LLM）打过交道的开发者来说，上下文（Context）管理都是一个绕不开的核心问题。它不仅决定了 AI 的智能程度，也直接关系到系统的性能和成本。一个天然的、不断累加对话历史的方案，很快就会在 Token 限制和高昂的 API 调用费用面前碰壁。

![cover_image](images/01.jpg)

# Claude Code长期记忆：优雅的上下文管理

Originalcc使用技巧cc使用技巧
西行树r

_2025年8月3日 07:52_

在小说阅读器读本章

去阅读

在小说阅读器中沉浸阅读

对于任何一个与大型语言模型（LLM）打过交道的开发者来说，上下文（Context）管理都是一个绕不开的核心问题。它不仅决定了 AI 的智能程度，也直接关系到系统的性能和成本。一个天然的、不断累加对话历史的方案，很快就会在 Token 限制和高昂的 API 调用费用面前碰壁。

Claude Code 的工程师显然深谙此道。他们没有选择暴力堆砌，而是设计了一套精巧的、多层级的上下文管理系统，堪称“优雅”的典范。

这套系统不仅实现了“过目不忘”的长期记忆，还引入了“适度遗忘”的艺术，在信息保真度与性能开销之间找到了一个绝佳的平衡点。

本文将深入剖析 Claude Code 的“数字记忆宫殿”，重点解读其三层记忆架构、核心的 wU2 压缩器以及那个神秘的“92%魔法阈值”，希望能为正在构建 AI 应用的你提供一些有价值的参考和启发。

## 🏛️ 三层记忆架构：从瞬时到永恒

Claude Code 的上下文管理系统并非铁板一块，而是借鉴了认知科学中的记忆模型，构建了一个由短期、中期和长期记忆协同工作的三层式（3-Tier）架构。

' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

### 第1层：短期记忆（Short-Term Memory）- 高速工作区

短期记忆层就像是 CPU 的 L1 缓存，为当前对话提供了一个高速、低延迟的“工作台”。它存储了最近的、未经处理的对话消息。

- 实现方式：一个简单的消息队列（Message Queue），保证对最新消息的 O(1) 访问效率。
- 核心功能：实时追踪当前对话的 Token 使用量，为后续的压缩决策提供依据。

为了提升性能，Token 使用量的检查并非从头遍历整个队列。Claude Code 的 VE 函数采用了一个非常聪明的策略：反向遍历。因为 Token 的使用情况统计通常包含在最新的 assistant 回复中，从后往前查找能以 O(k) 的时间复杂度（k 通常远小于 n）快速定位，极大地优化了效率。

' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

#### HY5 函数：智能过滤的三重检查机制

在反向遍历过程中，VE 函数调用 HY5 函数来确保获取的 Token 使用信息是有效和准确的。HY5 函数实现了一套严格的三重检查机制：

```
// Claude Code 短期记忆核心逻辑class ShortTermMemory {
  constructor() {
    this.messages = []; // O(1) 访问的消息队列this.maxTokens = 200000; // 动态Token限制this.compressionThreshold = 0.92; // 92% 压缩触发阈值
  }

  // VE函数的核心：从最新消息反向查找Token使用情况getCurrentUsage() {
    console.log('🔍 Checking memory usage...');
    let totalTokens = 0;
    // 从后往前遍历，因为usage信息通常在最近的AI回复里for (let i = this.messages.length - 1; i >= 0; i--) {
      const message = this.messages[i];
      if (message.usage) {
        totalTokens += this.calculateTotalTokens(message.usage);
        break; // 找到即停止，避免不必要的遍历
      }
    }
    return {
      used: totalTokens,
      total: this.maxTokens,
      percentage: totalTokens / this.maxTokens
    };
  }

  // yW5函数：检查是否需要启动压缩needsCompression() {
    const usage = this.getCurrentUsage();
    if (usage.percentage >= this.compressionThreshold) {
      console.log(`🚨 Memory usage at ${Math.round(usage.percentage * 100)}%, triggering compression!`);
      return true;
    }
    return false;
  }

  // zY5函数：精确的Token计算calculateTotalTokens(usage) {
    return usage.input_tokens +
           (usage.cache_creation_input_tokens || 0) +
           (usage.cache_read_input_tokens || 0) +
           usage.output_tokens;
  }
}
```

```
// Claude Code 短期记忆核心逻辑class ShortTermMemory {
constructor() {
    this.messages = []; // O(1) 访问的消息队列this.maxTokens = 200000; // 动态Token限制this.compressionThreshold = 0.92; // 92% 压缩触发阈值
  }

// VE函数的核心：从最新消息反向查找Token使用情况getCurrentUsage() {
    console.log('🔍 Checking memory usage...');
    let totalTokens = 0;
    // 从后往前遍历，因为usage信息通常在最近的AI回复里for (let i = this.messages.length - 1; i >= 0; i--) {
      const message = this.messages[i];
      if (message.usage) {
        totalTokens += this.calculateTotalTokens(message.usage);
        break; // 找到即停止，避免不必要的遍历
      }
    }
    return {
      used: totalTokens,
      total: this.maxTokens,
      percentage: totalTokens / this.maxTokens
    };
  }

// yW5函数：检查是否需要启动压缩needsCompression() {
    const usage = this.getCurrentUsage();
    if (usage.percentage >= this.compressionThreshold) {
      console.log(🚨 Memory usage at ${Math.round(usage.percentage * 100)}%, triggering compression!);
      returntrue;
    }
    returnfalse;
  }

// zY5函数：精确的Token计算calculateTotalTokens(usage) {
    return usage.input_tokens +
           (usage.cache_creation_input_tokens || 0) +
           (usage.cache_read_input_tokens || 0) +
           usage.output_tokens;
  }
}
```

### 第2层：中期记忆（Mid-Term Memory）- 智能蒸馏器

当短期记忆的使用率触及 92% 的阈值时，中期记忆层便会启动。它的核心是 wU2 压缩器，其工作不是粗暴地丢弃数据，而是进行“智能蒸馏”——调用一个专门的 LLM，将冗长的对话历史提炼成一份结构化的摘要。

这个过程的精髓在于 AU2 函数生成的压缩指令。它要求 LLM 按照一个精心设计的 8段式结构 来组织摘要。

8段式结构化总结 (The 8-Section Summary)

这个结构的设计并非随意，它模拟了开发者回顾项目时的思维模式，确保了上下文的完整性：

Primary Request and Intent (主要请求和意图): 用户的核心目标是什么？

Key Technical Concepts (关键技术概念): 对话中涉及的框架、算法、库等。

Files and Code Sections (文件和代码片段): 所有被提及或修改过的代码和文件路径。

Errors and fixes (错误和修复): 记录遇到的错误信息和最终的解决方案。

Problem Solving (问题解决过程): 解决问题的完整思路和决策路径。

All user messages (所有用户消息): 保留用户的关键指令和反馈。

Pending Tasks (待处理任务): 未完成的工作项，形成待办清单。

Current Work (当前工作状态): 明确记录当前对话中断时的进度。

这种结构化的方式，将无序的对话历史转化为一份有序、高信息密度的“项目文档”，为后续的对话提供了充分的背景信息。

' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

#### 压缩质量验证与优雅降级机制

wU2 压缩器在生成摘要后，不会直接应用压缩结果。相反，它实施了一套严格的质量验证机制，确保压缩过程不会损害关键信息的完整性。

#### 四重质量检查标准

```
// 压缩质量验证系统
classCompressionQualityValidator {
constructor() {
    this.qualityThresholds = {
      minFidelityScore: 80,      // 最低信息保真度 80%
      maxCompressionRatio: 0.15, // 最大压缩比 15%
      minSectionCoverage: 0.875, // 最低段落覆盖度 87.5%
      maxKeywordLoss: 0.20       // 最大关键词丢失率 20%
    };
  }

// 执行完整的质量验证流程
asyncvalidateCompressionQuality(compressedSummary, originalMessages) {
    console.log('🔍 开始压缩质量验证...');

    const checks = {
      // 检查 1：验证所有8个段落是否完整存在
      sectionsComplete: this.validateSectionCompleteness(compressedSummary),

      // 检查 2：验证关键信息保留情况
      keyInfoPreserved: awaitthis.validateKeyInformationPreservation(
        compressedSummary, originalMessages
      ),

      // 检查 3：验证上下文连续性
      contextContinuous: this.validateContextContinuity(compressedSummary),

      // 检查 4：验证压缩比例是否合理
      compressionRatioValid: this.validateCompressionRatio(
        compressedSummary, originalMessages
      )
    };

    // 计算综合保真度评分
    const fidelityScore = this.calculateFidelityScore(checks);

    const validationResult = {
      isValid: fidelityScore >= this.qualityThresholds.minFidelityScore,
      fidelityScore,
      checks,
      recommendations: this.generateImprovementRecommendations(checks)
    };

    console.log(`📊 压缩质量评估完成 - 保真度: ${fidelityScore}%`);
    return validationResult;
  }

// 检查 1：验证段落完整性
validateSectionCompleteness(summary) {
    const requiredSections = [\
      'Primary Request and Intent',\
      'Key Technical Concepts',\
      'Files and Code Sections',\
      'Errors and fixes',\
      'Problem Solving',\
      'All user messages',\
      'Pending Tasks',\
      'Current Work'\
    ];

    const foundSections = requiredSections.filter(section =>
      summary.toLowerCase().includes(section.toLowerCase()) ||
      this.findSectionByKeywords(summary, section)
    );

    const completeness = foundSections.length / requiredSections.length;

    return {
      score: completeness * 100,
      missingCount: requiredSections.length - foundSections.length,
      missingSections: requiredSections.filter(s => !foundSections.includes(s)),
      isValid: completeness >= this.qualityThresholds.minSectionCoverage
    };
  }

// 检查 2：关键信息保留验证
asyncvalidateKeyInformationPreservation(summary, originalMessages) {
    // 提取原始对话中的关键信息
    const keyInfo = this.extractKeyInformation(originalMessages);

    // 检查摘要中保留的关键信息比例
    const preservedInfo = {
      fileNames: this.checkFileNamePreservation(summary, keyInfo.fileNames),
      errorMessages: this.checkErrorMessagePreservation(summary, keyInfo.errorMessages),
      userCommands: this.checkUserCommandPreservation(summary, keyInfo.userCommands),
      technicalTerms: this.checkTechnicalTermPreservation(summary, keyInfo.technicalTerms)
    };

    const overallPreservation = Object.values(preservedInfo)
      .reduce((sum, item) => sum + item.preservationRate, 0) / 4;

    return {
      score: overallPreservation * 100,
      details: preservedInfo,
      isValid: overallPreservation >= (1 - this.qualityThresholds.maxKeywordLoss)
    };
  }

// 检查 3：上下文连续性验证
validateContextContinuity(summary) {
    const continuityIndicators = [\
      '用户首先', '然后', '接下来', '最后',\
      '问题出现', '解决方案', '结果',\
      '当前状态', '下一步'\
    ];

    const foundIndicators = continuityIndicators.filter(indicator =>
      summary.includes(indicator)
    );

    const continuityScore = Math.min(100, (foundIndicators.length / 5) * 100);

    return {
      score: continuityScore,
      foundIndicators: foundIndicators.length,
      isValid: continuityScore >= 60
    };
  }

// 检查 4：压缩比例验证
validateCompressionRatio(summary, originalMessages) {
    const originalLength = originalMessages
      .map(msg =>JSON.stringify(msg).length)
      .reduce((sum, len) => sum + len, 0);

    const compressedLength = summary.length;
    const compressionRatio = compressedLength / originalLength;

    return {
      originalLength,
      compressedLength,
      compressionRatio,
      isValid: compressionRatio <= this.qualityThresholds.maxCompressionRatio
    };
  }

// 综合保真度评分计算
calculateFidelityScore(checks) {
    const weights = {
      sectionsComplete: 0.3,    // 段落完整性权重 30%
      keyInfoPreserved: 0.4,    // 关键信息保留权重 40%
      contextContinuous: 0.2,   // 上下文连续性权重 20%
      compressionRatioValid: 0.1// 压缩比例权重 10%
    };

    returnMath.round(
      checks.sectionsComplete.score * weights.sectionsComplete +
      checks.keyInfoPreserved.score * weights.keyInfoPreserved +
      checks.contextContinuous.score * weights.contextContinuous +
      (checks.compressionRatioValid.isValid ? 100 : 50) * weights.compressionRatioValid
    );
  }
}
```

#### 优雅降级策略

当压缩质量验证失败时，Claude Code 不会简单地放弃压缩，而是采用优雅降级策略：

策略 1：自适应重压缩

- 如果保真度评分在 70-79% 之间，系统会调整压缩策略重新尝试
- 增加关键信息保留权重，降低压缩比例要求

策略 2：分段保留

- 如果某些段落信息丢失严重，保留原始消息中的关键部分
- 采用混合模式：压缩摘要 \+ 原始关键消息片段

策略 3：降级到简单截断

- 如果多次压缩尝试都失败，回退到保守的消息截断策略
- 保留最近 30% 的对话历史，确保上下文连续性

### 第3层：长期记忆（Long-Term Memory）- 持久化知识库

长期记忆是跨会话（cross-session）的知识存储层，通常以一个 CLAUDE.md 文件的形式存在。它存储的是那些经过中期记忆提炼后，被认为具有长期价值的信息，比如用户偏好、项目配置、通用解决方案等。

这一层不仅仅是简单的文件读写，更重要的是它支持向量化搜索（Vector Search）。当新的对话开始时，系统可以将用户的问题转换成向量，在长期记忆库中进行相似度检索，从而“回忆”起过去相关的经验，让 AI 具备跨越时间窗口解决问题的能力。

### 🎲 92%的科学密码与性能艺术

在 Claude Code 的设计中，92% 这个压缩阈值是一个非常有意思的细节。它并非工程师拍脑袋想出的数字，而是大量 A/B 测试和多目标优化的结果。

' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

- 阈值过低 (如 85%): 会导致压缩过于频繁，增加系统开销，并可能让用户感觉对话被频繁“重置”。
- 阈值过高 (如 95%): 虽然减少了压缩次数，但每次压缩时需要处理的数据量更大，可能导致明显的“卡顿”或“失忆”感，因为大量上下文被一次性转换。
- 92%: 则是在用户体验、性能开销和信息损失之间找到的“帕累托最优解”，一个让大多数用户几乎无感知的“静默”压缩点。

### 多目标优化的权重设计

' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

```
// 多目标优化权重配置
constOptimizationWeights = {
user_experience: 0.4,      // 用户体验权重最高
performance_overhead: 0.3, // 性能开销权重次之
information_fidelity: 0.2, // 信息保真度
compression_frequency: 0.1// 压缩频率权重最低
};

functioncalculateOptimalThreshold(testResults) {
let bestScore = 0;
let optimalThreshold = null;
for (const [threshold, metrics] ofObject.entries(testResults)) {
    const weightedScore =
      metrics.userExperience * OptimizationWeights.user_experience +
      metrics.performance * OptimizationWeights.performance_overhead +
      metrics.fidelity * OptimizationWeights.information_fidelity +
      metrics.frequency * OptimizationWeights.compression_frequency;
    if (weightedScore > bestScore) {
      bestScore = weightedScore;
      optimalThreshold = threshold;
    }
  }
return { threshold: optimalThreshold, score: bestScore };
}
ClaudeCode 不会在达到92%时才突然行动。它设计了一套渐进式的警告系统，提前与用户沟通内存状态：
```

### 三级预警机制详解

Level 1:Warning 状态 (60% - \_W5 函数触发) \- 触发条件：Token 使用率达到 60% - 显示信息：🟡 记忆使用量较高 (60%) - 用户操作：友好提醒，无需立即行动 - 系统行为：开始监控频率增加，从每 5 次对话检查一次变为每 2 次检查一次 - 预估剩余对话轮数：约 25-30 轮 Level 2: Urgent 状态 (80% - jW5 函数触发) \- 触发条件：Token 使用率达到 80% - 显示信息：🟠 记忆空间紧张，建议手动整理 - 用户操作：建议用户主动结束某些话题或重新开始对话 - 系统行为：每次对话后都进行 Token 检查，同时预热压缩系统 - 预估剩余对话轮数：约 8-12 轮 Level 3: Critical 状态 (92% - h11 函数触发) \- 触发条件：Token 使用率达到 92% - 显示信息：🔴 记忆空间已满，正在整理... - 用户操作：系统自动处理，用户无需操作 - 系统行为：立即触发 wU2 压缩器，显示压缩进度 - 压缩完成后：显示 ✅ 记忆整理完成，对话可以继续

' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

### 警告系统的实现机制:

```

// m11 函数：渐进式警告系统核心逻辑
classProgressiveWarningSystem {
constructor() {
    this.thresholds = {
      normal: 0.0,     // 正常状态
      warning: 0.6,    // _W5 - 60% 警告阈值
      urgent: 0.8,     // jW5 - 80% 紧急阈值
      critical: 0.92   // h11 - 92% 临界阈值
    };
    this.currentLevel = 'normal';
    this.lastWarningTime = 0;
    this.warningCooldown = 300000; // 5分钟警告冷却时间
  }

// 计算当前警告等级和对应操作
assessMemoryStatus(currentUsage, maxTokens) {
    const percentage = currentUsage / maxTokens;
    const now = Date.now();

    // 防止警告信息过于频繁
    if (now - this.lastWarningTime < this.warningCooldown &&
        percentage < this.thresholds.critical) {
      return { level: this.currentLevel, shouldDisplay: false };
    }

    let newLevel, message, action, estimatedRounds;

    if (percentage >= this.thresholds.critical) {
      newLevel = 'critical';
      message = '🔴 记忆空间已满，正在整理...';
      action = 'auto_compress';
      estimatedRounds = 0;
    } elseif (percentage >= this.thresholds.urgent) {
      newLevel = 'urgent';
      message = '🟠 记忆空间紧张，建议手动整理';
      action = 'suggest_manual_compress';
      estimatedRounds = this.calculateRemainingRounds(percentage, 0.92);
    } elseif (percentage >= this.thresholds.warning) {
      newLevel = 'warning';
      message = '🟡 记忆使用量较高';
      action = 'gentle_reminder';
      estimatedRounds = this.calculateRemainingRounds(percentage, 0.92);
    } else {
      newLevel = 'normal';
      message = ✅ 记忆健康 (${Math.round(percentage * 100)}%);
      action = 'none';
      estimatedRounds = this.calculateRemainingRounds(percentage, 0.92);
    }

    // 更新状态
    if (newLevel !== this.currentLevel) {
      this.currentLevel = newLevel;
      this.lastWarningTime = now;
    }

    return {
      level: newLevel,
      message,
      action,
      percentage: Math.round(percentage * 100),
      estimatedRounds,
      shouldDisplay: true
    };
  }

// 估算剩余对话轮数
calculateRemainingRounds(currentRatio, targetRatio) {
    if (currentRatio >= targetRatio) return0;

    // 基于历史数据：平均每轮对话消耗约 1.5-2% 的 Token
    const avgTokenPerRound = 0.0175; // 1.75%
    const remainingRatio = targetRatio - currentRatio;
    returnMath.floor(remainingRatio / avgTokenPerRound);
  }

// 生成用户友好的进度条显示
generateProgressBar(percentage) {
    const barLength = 20;
    const filled = Math.round((percentage / 100) * barLength);
    const empty = barLength - filled;
    const progressBar = '█'.repeat(filled) + '░'.repeat(empty);
    return [${progressBar}] ${percentage}%;
  }
}
```

## 🗜️ 智能文件恢复：不止是压缩

wU2 压缩器最智能的一点，可能在于压缩之后的操作。它并没有将所有信息都“压扁”，而是通过 TW5 函数执行一个关键步骤：智能文件恢复 (Intelligent File Restoration)。

对话历史被压缩了，但那些在对话中被频繁读写、修改的核心代码文件，其内容会被智能地重新加载回上下文中。这就像一个程序员清理了桌面，但把最重要的几份文件留在了手边。

TW5 函数通过一套评分算法来决定恢复哪些文件，其评分标准包括：

- 访问时间: 最近访问的文件权重更高。
- 访问频率: 操作次数越多的文件越重要。
- 操作类型: 写操作的权重高于读操作。
- 文件类型: 代码文件（.js, .py）的优先级高于配置文件（.json），更高于文档（.md）。

这个机制确保了即使在上下文被大幅压缩后，AI 依然能无缝地继续之前的工作，因为它最重要的“工作文件”并未丢失。

```
// TW5 函数：智能文件恢复评分系统
classIntelligentFileRestorer {
constructor() {
    // qW5: 文件数量限制配置
    this.maxFiles = 20;
    // LW5: 单文件Token限制配置
    this.maxTokensPerFile = 8192;
    // MW5: 总恢复Token限制配置
    this.totalTokenLimit = 32768;

    // 评分权重配置
    this.scoringWeights = {
      temporal: 0.35,      // 时间因素权重 35%
      frequency: 0.25,     // 频率因素权重 25%
      operation: 0.20,     // 操作类型权重 20%
      fileType: 0.15,      // 文件类型权重 15%
      project: 0.05        // 项目关联度权重 5%
    };
  }

// 核心评分算法
calculateImportanceScore(fileMetadata) {
    let totalScore = 0;

    // 1. 时间因素评分 (0-100分)
    const temporalScore = this.calculateTemporalScore(fileMetadata);
    totalScore += temporalScore * this.scoringWeights.temporal;

    // 2. 频率因素评分 (0-100分)
    const frequencyScore = this.calculateFrequencyScore(fileMetadata);
    totalScore += frequencyScore * this.scoringWeights.frequency;

    // 3. 操作类型评分 (0-100分)
    const operationScore = this.calculateOperationScore(fileMetadata);
    totalScore += operationScore * this.scoringWeights.operation;

    // 4. 文件类型评分 (0-100分)
    const fileTypeScore = this.calculateFileTypeScore(fileMetadata);
    totalScore += fileTypeScore * this.scoringWeights.fileType;

    // 5. 项目关联度评分 (0-100分)
    const projectScore = this.calculateProjectRelevanceScore(fileMetadata);
    totalScore += projectScore * this.scoringWeights.project;
    returnMath.round(totalScore);
  }

// 1. 时间因素评分：最近访问的文件优先级更高
calculateTemporalScore(file) {
    const now = Date.now();
    const hoursSinceLastAccess = (now - file.lastAccessTime) / (1000 * 60 * 60);

    // 时间衰减函数：24小时内满分，之后指数衰减
    if (hoursSinceLastAccess <= 1) {
      return100; // 1小时内 = 满分
    } elseif (hoursSinceLastAccess <= 6) {
      return90;  // 6小时内 = 90分
    } elseif (hoursSinceLastAccess <= 24) {
      return75;  // 24小时内 = 75分
    } else {
      // 24小时后开始衰减：75 * e^(-0.1 * (hours - 24))
      returnMath.max(10, 75 * Math.exp(-0.1 * (hoursSinceLastAccess - 24)));
    }
  }

// 2. 频率因素评分：操作越频繁优先级越高
calculateFrequencyScore(file) {
    const totalOperations = file.readCount + file.writeCount + file.editCount;

    // 基于操作总数的评分
    let score = Math.min(80, totalOperations * 5); // 最高80分

    // 最近操作频率加成
    const recentOperations = file.operationsInLastHour || 0;
    score += Math.min(20, recentOperations * 10); // 最高20分加成
    returnMath.min(100, score);
  }

// 3. 操作类型评分：写操作 > 编辑操作 > 读操作
calculateOperationScore(file) {
    let score = 0;

    // 写操作权重最高
    score += file.writeCount * 15;

    // 编辑操作权重中等
    score += file.editCount * 10;

    // 读操作权重较低
    score += file.readCount * 3;

    // 如果最后一次操作是写操作，额外加分
    if (file.lastOperation === 'write') {
      score += 25;
    } elseif (file.lastOperation === 'edit') {
      score += 15;
    }
    returnMath.min(100, score);
  }

// 4. 文件类型评分：代码文件 > 配置文件 > 文档文件
calculateFileTypeScore(file) {
    const extension = file.path.split('.').pop().toLowerCase();

    // 编程语言文件优先级最高
    const codeExtensions = {
      'js': 100, 'ts': 100, 'jsx': 95, 'tsx': 95,
      'py': 90, 'java': 85, 'cpp': 85, 'c': 85,
      'go': 80, 'rs': 80, 'php': 75, 'rb': 75
    };

    // 配置文件优先级中等
    const configExtensions = {
      'json': 70, 'yaml': 65, 'yml': 65, 'toml': 60,
      'xml': 55, 'ini': 50, 'env': 50, 'config': 50
    };

    // 文档文件优先级较低
    const docExtensions = {
      'md': 40, 'txt': 30, 'doc': 25, 'docx': 25,
      'pdf': 20, 'html': 35, 'css': 45
    };
    if (codeExtensions[extension]) {
      return codeExtensions[extension];
    } elseif (configExtensions[extension]) {
      return configExtensions[extension];
    } elseif (docExtensions[extension]) {
      return docExtensions[extension];
    }

    return30; // 未知类型默认30分
  }

// 5. 项目关联度评分：与当前项目相关性
calculateProjectRelevanceScore(file) {
    let score = 50; // 基础分50

    // 检查是否在项目根目录或核心目录中
    const pathLower = file.path.toLowerCase();
    if (pathLower.includes('/src/') || pathLower.includes('\\src\\')) {
      score += 30; // 源代码目录加分
    }
    if (pathLower.includes('/components/') || pathLower.includes('/modules/')) {
      score += 20; // 组件/模块目录加分
    }
    if (pathLower.includes('/test/') || pathLower.includes('/spec/')) {
      score += 10; // 测试目录适度加分
    }

    // 检查是否为关键文件
    const fileName = file.path.split('/').pop().toLowerCase();
    const criticalFiles = [\
      'package.json', 'pom.xml', 'cargo.toml', 'go.mod',\
      'dockerfile', 'docker-compose.yml', 'makefile',\
      'readme.md', 'index.js', 'main.py', 'app.js'\
    ];
    if (criticalFiles.includes(fileName)) {
      score += 25; // 关键文件大幅加分
    }
    returnMath.min(100, score);
  }

// 智能选择算法：在约束条件下选择最优文件组合
selectOptimalFileSet(rankedFiles) {
    const selectedFiles = [];
    let totalTokens = 0;
    let fileCount = 0;

    // 按分数排序
    const sortedFiles = rankedFiles.sort((a, b) => b.score - a.score);
    for (const file of sortedFiles) {
      // 检查约束条件
      if (fileCount >= this.maxFiles) {
        console.log(📊 达到文件数量限制: ${this.maxFiles});
        break;
      }
      if (file.estimatedTokens > this.maxTokensPerFile) {
        console.log(⚠️ 文件 ${file.path} 超出单文件限制，跳过);
        continue;
      }
      if (totalTokens + file.estimatedTokens > this.totalTokenLimit) {
        console.log(📊 添加 ${file.path} 将超出总Token限制);
        // 尝试背包问题优化：寻找更小的高分文件
        const remainingTokens = this.totalTokenLimit - totalTokens;
        const alternativeFile = this.findBestFitFile(
          sortedFiles.slice(sortedFiles.indexOf(file) + 1),
          remainingTokens
        );
        if (alternativeFile) {
          selectedFiles.push(alternativeFile);
          totalTokens += alternativeFile.estimatedTokens;
          fileCount++;
        }
        continue;
      }
      selectedFiles.push(file);
      totalTokens += file.estimatedTokens;
      fileCount++;
    }
    return {
      files: selectedFiles,
      totalFiles: fileCount,
      totalTokens,
      efficiency: (totalTokens / this.totalTokenLimit) * 100
    };
  }
}
```

## 🚀 对开发者的启示

Claude Code 的上下文管理系统为我们构建复杂的 AI 应用提供了宝贵的经验：

分层思想是王道: 不要试图用一个系统解决所有问题。将记忆/上下文管理分解为高速的短期层、负责整理的中期层和用于持久化的长期层，是一种非常清晰和可扩展的架构。

优雅降级，而非硬性限制: 与其在达到 Token 上限时粗暴地截断，不如设计一套智能压缩和摘要机制。这能显著提升应用的“智能感”和鲁棒性。

性能优化在于细节: 反向遍历查找 Token、结构化摘要、向量化检索等技术，都是在细节之处提升系统性能和用户体验的典范。

透明化是最好的交互: 将系统内部状态（如内存使用率）通过渐进式警告的方式暴露给用户，可以建立信任，并将潜在的负面体验转化为正向的互动。

最终，Claude Code 告诉我们，真正的智能记忆，不在于无限的容量，而在于管理的智慧——知道什么该记住，什么该忘记，以及如何优雅地忘记。这不仅是 AI 设计的哲学，或许也是我们程序员日常工作中值得借鉴的思考。

' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

预览时标签不可点

Close

更多

Name cleared

**微信扫一扫赞赏作者**

Like the AuthorOther Amount

赞赏后展示我的头像

作品

暂无作品

Like the Author

Other Amount

¥

最低赞赏 ¥0

OK

Back

**Other Amount**

更多

赞赏金额

¥

最低赞赏 ¥0

1

2

3

4

5

6

7

8

9

0

.

Close

更多

搜索「」网络结果

Close

**调整当前正文文字大小**

更多

100%

​

Comment

暂无留言

1 comment(s)

已无更多数据

Send Message

写留言:

Scan to Follow

继续滑动看下一个

轻触阅读原文

![](images/02.jpg)

西行树r

向上滑动看下一个

当前内容可能存在未经审核的第三方商业营销信息，请确认是否继续访问。

继续访问Cancel

[微信公众平台广告规范指引](javacript:;)

Got It

Scan with Weixin to

use this Mini Program

CancelAllow

CancelAllow

CancelAllow

×分析

![跳转二维码](images/03.jpg)

![作者头像](images/02.jpg)

微信扫一扫可打开此内容，

使用完整服务

![](images/04.jpg)

西行树r

已关注

Like

Share

Popular

Comment

: ，，，，，，，，，，，，.VideoMini ProgramLike，轻点两下取消赞Wow，轻点两下取消在看ShareCommentFavorite听过

可在「公众号 \> 右上角  \> 划线」找到划线过的内容

![划线引导图](images/05.jpg)

OK

,

,

选择留言身份

**Comment**

暂无留言

1 comment(s)

已无更多数据

Send Message

写留言:

Close

更多

关闭

## 确认提交投诉

你可以补充投诉原因（选填）

确定

wxa-pcopensdk
