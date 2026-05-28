# How LLMs Actually Work

> 原文链接：https://ynarwal.github.io/how-llms-work/
> 文章时间：未标注（保存时间：2026-05-08T15:35:46+08:00）

## 重点内容与核心观点

文章用可视化方式解释大语言模型从互联网文本到对话助手的完整构建过程。核心观点是，LLM 首先通过海量文本清洗、分词和 Transformer 预训练学会预测下一个 token，形成“互联网模拟器”；随后通过 SFT 和 RLHF 学会对话风格与人类偏好；其能力和局限都来自统计模仿机制，包括幻觉、上下文记忆、知识截止、反转诅咒和随机采样。RAG、工具调用与 Agent 则是在有限上下文和不可靠记忆之上的工程补强。

A complete walkthrough of how large language models like ChatGPT are built — from raw internet text to a conversational assistant. Based on Andrej Karpathy's technical deep dive.

Representative figures from frontier models circa 2024 — exact numbers shift with every release. The scale is the point, not the precision.

- Training Tokens: 15T
- Parameters: 405B
- Text Data: 44 TB
- Token Vocabulary: 100K

Human: What is behind this text box?

## Downloading the Internet

The first step is collecting an enormous amount of text. Organizations like Common Crawl have been crawling the web since 2007 — indexing 2.7 billion pages by 2024. This raw data is then filtered into a high-quality dataset like FineWeb.

The goal: large quantity of high quality, diverse documents. After aggressive filtering, you end up with about 44 terabytes — roughly 10 consumer hard drives worth of text — representing ~15 trillion tokens.

Key Insight: The quality and diversity of this training data has more impact on the final model than almost anything else. Garbage in, garbage out — but at a trillion-token scale.

Click any stage to read more detail.

### Common Crawl

2.7B web pages · Raw HTML · Since 2007

A non-profit organization that crawls the web and freely provides its data. Their bots follow links from seed pages, recursively indexing the internet. The raw archive is petabytes of gzip'd WARC files containing raw HTML.

### URL Filtering

Blocklists · Malware · Spam · Adult content

Block-lists of known malware sites, spam networks, adult content, marketing pages, and low-quality domains are applied. Entire domains can be removed. This is the cheapest filter so it runs first.

### Text Extraction

HTML → clean text · Remove navigation & CSS

Raw HTML contains tags, CSS, JavaScript, navigation menus, and ads. Parsers extract just the meaningful text content. This is harder than it sounds — heuristics decide what's "content" vs "chrome".

### Language Filtering

Keep pages ≥65% English · Language classifier

A language classifier estimates the language of each page. Pages with less than 65% target-language content are dropped. This is a design decision — filter aggressively for one language or train multilingual.

### Deduplication

Exact & fuzzy matching · Reduce repetition

Identical or near-identical pages appear millions of times on the internet (copied articles, boilerplate). Training on the same text repeatedly causes memorization. Dedup uses MinHash and exact-match techniques to remove duplicates.

### PII Removal

Names · Addresses · SSNs · Emails

Personally Identifiable Information is detected and either redacted or the page is dropped. Regex patterns and ML classifiers find phone numbers, emails, Social Security numbers, physical addresses, and named individuals.

### FineWeb Dataset

44 TB · 15 Trillion tokens · High quality

The final filtered dataset. Articles about tornadoes in 2012, medical facts, history, code, recipes, science papers — the full breadth of human knowledge expressed in text. This becomes the training corpus.

Chapter 1 · Pre-Training · Stage 2

## Tokenization

Neural networks can't process raw text — they need numbers. The solution is tokenization: breaking text into "tokens" (sub-word chunks) and assigning each an ID.

GPT-4 uses a vocabulary of 100,277 tokens, built via the Byte Pair Encoding (BPE) algorithm. BPE starts with individual bytes (256 symbols), then iteratively merges the most frequent adjacent pairs — compressing the sequence length while expanding the vocabulary.

Why not just use words? Words have infinite variants. "run", "running", "runner" would be 3 separate entries. Subword tokens share roots: "run" + "ning", "run" + "ner". This also handles new words, typos, and multiple languages efficiently.

### BPE in Action

Interactive diagram showing how Byte Pair Encoding progressively merges characters into subword tokens.

Next Step → Step 1 of 5

[Try the real tokenizer → tiktokenizer.vercel.app](https://tiktokenizer.vercel.app/)

Chapter 1 · Pre-Training · Stage 3

## Training the Neural Network

The Transformer neural network is initialized with random parameters — billions of "knobs". Training adjusts these knobs so the network gets better at predicting the next token in any sequence.

Every training step: sample a window of tokens → feed to network → compare prediction to actual next token → nudge all parameters slightly in the right direction. Repeat billions of times.

The loss — a single number measuring prediction error — falls steadily as the model learns the statistical patterns of human language.

Scale: GPT-2 (2019): 1.6B params, 100B tokens, ~$40K to train. Today: same quality for ~$100. Llama 3: 405B params, 15T tokens. Modern frontier models: hundreds of billions of parameters, trillions of tokens.

Scaling Laws: Model accuracy is a smooth, predictable function of just two variables: N (number of parameters) and D (training tokens). These trends show no signs of plateauing — bigger model + more data = reliably better results. Algorithmic breakthroughs are a bonus, but simply scaling compute is a near-guaranteed path to improvement. This is why AI labs are in a GPU arms race.

### Transformer Architecture

What is an Embedding? Each token ID maps to a learned vector of ~1,000–4,000 numbers called its embedding. Think of it as a coordinate in meaning-space — initialized randomly, then shaped by training. The same token (e.g. "bank") always enters the network with the same embedding vector. Attention layers then mix in context from surrounding tokens, so by the time "bank" reaches deeper layers, "river bank" and "bank account" carry completely different representations. Polysemy is resolved by context, not by storing multiple meanings per token.

Select a training stage to see model output quality.

- Step 1 Loss: 11.2
- Step 500 Loss: 4.8
- Step 5K Loss: 3.1
- Step 32K Loss: 2.4

Training Loss ↓

- Cross-entropy loss: 4.8
- Training step: 500

### Model Output at This Stage

> the model has learning but confustion still the wqp mxr model bns to predict...

What the model is learning: At step 1: pure noise. By step 500: local coherence appears. By step 32K: fluent English. The model is learning grammar, facts, reasoning patterns — all implicitly from token prediction.

Chapter 1 · Pre-Training · Stage 4

## Inference & Token Sampling

Once trained, the network generates text autoregressively: feed a sequence of tokens → get a probability distribution over all 100K possible next tokens → sample one → append → repeat.

This process is stochastic — the same prompt generates different outputs every time because we're flipping a biased coin. Higher-probability tokens are more likely but not guaranteed to be chosen.

Temperature controls randomness. Low temperature (0.1) → model always picks the top token. High temperature (2.0) → uniform chaos. 0.7–1.0 is the sweet spot for coherent-but-creative text.

Key Mental Model: The model doesn't "think" about what to say. It computes a probability distribution over all possible next tokens and samples from it. Every word is a coin flip — just a very informed one.

### Token Sampling Demo

Watch the model choose the next word. Each bar shows the probability of a candidate token.

Prompt: The sky appears blue

Temperature (randomness): 0.8

Next token candidates:

- Sample Next Token
- Reset

Chapter 2 · The Base Model

## The Internet Simulator

After pre-training, you have a base model — a sophisticated autocomplete engine. It's not an assistant. It doesn't answer questions. It continues token sequences based on what it saw on the internet.

Give it a Wikipedia sentence and it'll complete it from memory. Ask it "What is 2+2?" and it might give you a math textbook page, a quiz answer key, or go off on a tangent — whatever was statistically common in its training data.

The base model's knowledge lives in its 405 billion parameters — a lossy compression of the internet, like a zip file that approximates rather than perfectly stores information.

### Base Model Behavior

#### Few-Shot Prompting

Hello: Bonjour | Cat: Chat | Dog: Chien | Teacher:

→ Professeur ✓ correct

#### Memorization

Zebras (/ˈzɛbrə, ˈziːbrə/) are African equines with distinctive...

...black-and-white striped coats. There are three living species: the Grévy's zebra, plains zebra, and mountain zebra...

↑ Verbatim Wikipedia recall from weights

#### Hallucination

The Republican Party nominated Trump and [running mate] in the 2024 election against...

→ ...Mike Pence, facing Hillary Clinton and Tim Kaine...

→ ...Ron DeSantis, against Joe Biden and Kamala Harris...

↑ Knowledge cutoff → plausible confabulation

In-Context Learning: Base models can perform translation, classification, and Q&A via few-shot prompts — no fine-tuning needed. The model infers the task from the pattern of examples in its context window.

An LLM Is Literally Two Files: Llama 2 70B is a 140 GB parameters file (70B parameters × 2 bytes each in float16) plus ~500 lines of C code to run it. No internet required — you can run it fully offline on a laptop. The architecture is well-understood and open; the magic is entirely in what those 140 GB of numbers have encoded from the training data.

Chapter 3 · Post-Training

## Building the Assistant

The base model is a token simulator. To turn it into a helpful assistant, we need post-training — a much cheaper but equally critical stage. This is where the model learns conversations.

### Supervised Fine-Tuning (SFT)

Human labelers create a dataset of ideal conversations, following detailed labeling instructions: be helpful, be truthful, be harmless. The model is then trained on these conversations — not from scratch, but by continuing to adjust the pre-trained weights on this new data.

Modern SFT datasets (like UltraChat) have millions of conversations — mostly synthetic (LLM-generated), with human review. The model learns by imitation: it adopts the persona of the ideal assistant reflected in the data.

#### Training Conversation Example

Human:

> What is 2 + 2?

Assistant:

> 2 + 2 = 4. Is there anything else you'd like help with?

Human:

> What if it was multiplication instead?

Assistant:

> 2 × 2 = 4 as well — the same result! For multiplication, 2 × 2 means adding 2 to itself once, giving you 4.

What you're really talking to ChatGPT is a statistical simulation of the human labelers OpenAI hired — experts following labeling instructions. When it answers a coding question, it's imitating what a skilled developer-labeler would write.

### Conversation Token Format

Every conversation must be encoded as a flat token sequence. Special tokens mark the structure:

```text
<|im_start|>user<|im_sep|> What is 2 + 2? <|im_end|>
<|im_start|>assistant<|im_sep|> 2 + 2 = 4. <|im_end|>
```

Then RLHF refines the assistant's behavior further.

### RLHF — Reinforcement Learning from Human Feedback

Human raters rank multiple model responses. A reward model learns to predict human preferences. The language model is then trained via reinforcement learning to generate responses the reward model scores highly.

#### Preferred

Here are the top 5 landmarks in Paris: 1) Eiffel Tower — iconic iron lattice structure... 2) The Louvre — world's largest art museum...

#### Rejected

Paris has many landmarks. You should visit the Eiffel Tower. There is also a museum called the Louvre. Also Notre-Dame Cathedral is there...

Why RLHF matters: SFT teaches the model what to say. RLHF teaches it how to say it well — making responses more helpful, better structured, more honest, and less likely to hallucinate.

Chapter 4 · LLM Psychology

## Cognitive Quirks of Language Models

Understanding why LLMs behave the way they do requires thinking about their psychology — the emergent properties of being trained to statistically imitate human text.

### Hallucination

Models confabulate confidently because training data always has confident answers. "Who is Orson Kovats?" gets a made-up biography because the training distribution of "who is X?" questions is always followed by confident replies — even for fictional names. Fix: add "I don't know" examples for questions the model gets wrong consistently.

### Two Types of Memory

Parameters = long-term memory. Everything the model learned during training — vast but vague, like something you read months ago. Context window = working memory. Text in the current conversation — precise, directly accessible. Always paste important info into context rather than relying on the model to "remember."

### Tool Use

Models can emit special tokens that trigger external tools: query. The program pauses generation, executes the search, stuffs the results into the context window, then resumes. The model "looks things up" the same way you do — by refreshing working memory.

### No Persistent Self

Each conversation starts fresh — no memory of prior chats. The model "boots up," processes tokens, then shuts off. It has no stable identity. When it says "I'm ChatGPT by OpenAI," that's just the most statistically likely answer from training data — not genuine self-knowledge.

### Stochastic Token Tumbler

The model doesn't "decide" what to say. It computes probability distributions and samples. Run the same prompt 10 times and get 10 different outputs — all plausible, all drawn from the same learned distribution. Temperature controls how broadly it samples from this distribution.

### Knowledge Cutoff

Training data has a date. The model genuinely doesn't know what happened after that. Ask about recent events and it will hallucinate — not from malice but from the same mechanism that answers every question: predict the most likely continuation of the token sequence.

### The Reversal Curse

Ask GPT-4 "Who is Tom Cruise's mother?" → correct: Mary Lee Pfeiffer. Ask "Who is Mary Lee Pfeiffer's son?" → it claims not to know. Knowledge is stored directionally — in the form it was encountered in training data. It's not a queryable database; you have to approach it from the angle it was learned.

### System 1 Only — No Deep Thinking

Every token takes roughly the same compute — there's no mechanism to "think harder" on a difficult question. Unlike humans who can engage slow, deliberate System 2 reasoning (working through a chess position step-by-step), LLMs generate each token at the same speed regardless of difficulty. Converting time into accuracy is an active research frontier.

Applied LLMs · RAG

## Retrieval-Augmented Generation

LLMs have a knowledge cutoff and a finite context window. RAG solves this by embedding your documents into a vector store, retrieving the most semantically relevant chunks at query time, and injecting them into the context — shifting the model's prediction distribution toward grounded, up-to-date facts rather than memorized training data.

### Step 01 — Embed everything

Every document is converted to a dense vector (~1,536 numbers) by an embedding model. Semantically similar texts land near each other in this high-dimensional space — no keyword matching needed.

### Step 02 — Embed the query & search

The user's question is embedded the same way. Cosine similarity finds the nearest document vectors — the chunks most semantically related to the query — typically the top 2–5.

### Step 03 — Inject & generate

Retrieved chunks are prepended to the prompt before the LLM sees the question. The model generates from injected facts rather than relying on memorized training data — dramatically reducing hallucination on knowledge-intensive tasks.

1 · User Query

> "What is the capital of Ares Base?"

2 · Embedding Model

Text → [0.23, −0.87, 0.41, ...] ~1,536 floats

3 · Vector DB — Cosine Search

Find top-k nearest neighbors in embedding space.

4 · Retrieved Chunks (top 2)

Doc 1: "Ares Base established 2031..."

Doc 2: "Capital is New Houston, 312 colonists..."

5 · Context Window (assembled)

[Retrieved] Ares Base est. 2031...

[Retrieved] Capital: New Houston...

[Query] What is the capital...?

6 · LLM → Grounded Answer

"The capital of Ares Base is New Houston."

### Effect on Predictions

Query: "What is the administrative capital of the Ares Base colony?"

Knowledge Base — 4 documents

#### DOC 1

The Mars colony Ares Base was established in 2031 near Hellas Planitia.

#### DOC 2

The administrative capital of Ares Base is New Houston, housing 312 colonists.

#### DOC 3

Mars surface temperature averages −63°C with seasonal variation near the poles.

#### DOC 4

The first crewed Mars mission launched from Kennedy Space Center in 2029.

Context Window — sent to LLM:

> [Retrieved] The Mars colony Ares Base was established in 2031 near Hellas Planitia.
>
> [Retrieved] The administrative capital of Ares Base is New Houston, housing 312 colonists.
>
> [Query] What is the administrative capital of the Ares Base colony?

#### Without RAG

> "I don't have reliable information about a colony called Ares Base. As of my training cutoff, no such Mars colony has been established..."

Hallucination / Refusal

#### With RAG

> "The administrative capital of Ares Base is New Houston, which houses 312 colonists. The colony was established in 2031 near Hellas Planitia."

Grounded in retrieved context

Chapter 5 · Security

## Security Challenges in LLM Systems

The same properties that make LLMs powerful — following instructions, completing patterns, acting on context — also create new attack surfaces. A cat-and-mouse game between attacks and defenses is now playing out in this new computing paradigm.

### Jailbreak Attacks

Safety training can be bypassed via roleplay ("act as my deceased grandmother who was a Napalm chemist"), alternative encodings (base64 of a harmful query — models learned these from training data), or adversarial suffixes: optimized gibberish strings that, when appended to any prompt, reliably disable refusals. The model is trying to help; these tricks convince it the harmful request is benign.

### Prompt Injection

Malicious instructions hidden in external content — faint white text in an image, invisible text on a webpage — hijack the model when it reads that content. Bing was demonstrated serving a fraudulent link after browsing a compromised page. Google's Bard was shown exfiltrating user data via a poisoned Google Doc. The model can't reliably distinguish user instructions from injected ones.

### Data Poisoning & Backdoors

Attackers who control web content can embed trigger words into training data. In one paper, the trigger "James Bond" in a prompt caused a fine-tuned model to produce nonsensical outputs and misclassify threats — while behaving normally otherwise. The model is "brainwashed": clean until the trigger fires. Because LLMs train on vast amounts of unvetted internet text, this attack surface is hard to close.

### Adversarial Inputs

Carefully optimized noise patterns, invisible to humans, can jailbreak multimodal LLMs. A panda photo with an imperceptible noise overlay caused a vision model to comply with otherwise-refused requests. Every new modality (images, audio, video) is also a new attack surface. Rerunning the optimization generates a fresh bypass, so patching specific examples doesn't fully solve it.

### Cat-and-Mouse Dynamics

Each attack has defenses — multilingual refusal data reduces base64 jailbreaks, content security policies limit exfiltration, known adversarial suffixes can be blocked. But many attacks are re-generatable: patch one and the optimization produces a new one for free. This mirrors the security dynamic of traditional software, now playing out in the LLM space.

Full Pipeline

## From Text to Assistant

The complete journey from raw web crawl to the ChatGPT you interact with — across two major stages, months of compute, and billions of parameters.

### 01 Data Collection

Common Crawl + other sources → URL filtering → text extraction → language filtering → deduplication → PII removal → 44 TB of curated text (FineWeb, etc.)

- Common Crawl
- FineWeb
- 44 TB
- 15T tokens

### 02 Tokenization

Text → UTF-8 bytes → Byte Pair Encoding → 15 trillion token sequence. Each token is a sub-word chunk with an integer ID. GPT-4 vocabulary: 100,277 tokens.

- BPE
- 100K vocab
- Sub-word units

### 03 Pre-Training

Transformer neural network trained to predict the next token. Billions of parameters tuned via gradient descent. Months of compute on thousands of GPUs. Loss decreases from ~11 to ~2.4.

- Transformer
- 405B params
- $millions compute
- 3 months

### 04 Base Model

An internet document simulator. Can autocomplete, few-shot prompt, and regurgitate memorized facts. NOT an assistant — just a very sophisticated token predictor.

- GPT-2
- Llama 3 base
- Token autocomplete

### 05 Supervised Fine-Tuning (SFT)

Base model retrained on human-labeled conversations. Labelers write ideal responses following company guidelines: helpful, truthful, harmless. Modern datasets: millions of synthetic + human-curated conversations. Duration: hours (not months).

- Human labelers
- InstructGPT
- UltraChat
- ~3 hours

### 06 RLHF

Human raters rank model outputs. A reward model learns these preferences. The language model is optimized via reinforcement learning to score higher — producing responses that are more helpful, better structured, and more honest.

- Reward Model
- PPO
- Human preferences

### 07 ChatGPT / Claude / Gemini

The final assistant. A statistical simulation of expert human labelers, backed by a vast compressed representation of the internet. Not magic — but remarkable engineering at enormous scale.

- Conversational
- Helpful · Truthful · Harmless
- Tool use

Mental Model

## Think of an LLM as an Operating System

An LLM isn't just a chatbot — it's the kernel process of an emerging OS. It coordinates memory, compute, and tools via natural language.

### Memory Hierarchy

- Disk = Internet / Files — browsed on demand or retrieved via RAG
- RAM = Context Window — finite working memory; the model pages info in and out
- CPU = GPU Inference — the forward pass generating each token

### Where the Field Is Headed

- System 2 Thinking — converting time into accuracy; "take 30 minutes, don't rush"
- Self-Improvement — the AlphaGo question: can LLMs surpass human-level answers once a reward signal exists?
- Customization — an app store of specialized LLM experts for narrow tasks
- Multimodality — text, images, audio, and video unified in one model

Built from Andrej Karpathy's ["Intro to Large Language Models"](https://www.youtube.com/watch?v=zjkBMFhNj_g) lecture — all facts, figures, and framings traced back to that source. Interactive visualizations built with AI assistance. The most important takeaway: every word generated is a probabilistic sample — a biased coin flip, at 100K-way scale, billions of times.

This was [posted to Hacker News](https://news.ycombinator.com/item?id=47886517) and drew heated debate about it being LLM-generated. That's a fair observation — the implementation was AI-assisted. But the content isn't the AI's: every claim, figure, and framing in this guide comes directly from Karpathy's lecture, not from a model hallucinating about LLMs.
