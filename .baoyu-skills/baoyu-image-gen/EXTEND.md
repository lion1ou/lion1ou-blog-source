---
version: 1
default_provider: google
default_quality: 2k
default_aspect_ratio: "16:9"
default_image_size: 2K
default_image_api_dialect: null
default_model:
  google: "gemini-3-pro-image-preview"
  openai: "gpt-image-2"
  azure: null
  openrouter: "google/gemini-3.1-flash-image-preview"
  dashscope: "qwen-image-2.0-pro"
  zai: "glm-image"
  minimax: "image-01"
  replicate: "google/nano-banana-2"
  jimeng: null
  seedream: null
  codex-cli: "codex-image-gen"
batch:
  max_workers: 10
  provider_limits:
    google:
      concurrency: 3
      start_interval_ms: 1100
    openai:
      concurrency: 3
      start_interval_ms: 1100
    azure:
      concurrency: 3
      start_interval_ms: 1100
    openrouter:
      concurrency: 3
      start_interval_ms: 1100
    dashscope:
      concurrency: 3
      start_interval_ms: 1100
    zai:
      concurrency: 3
      start_interval_ms: 1100
    minimax:
      concurrency: 3
      start_interval_ms: 1100
    replicate:
      concurrency: 5
      start_interval_ms: 700
    codex-cli:
      concurrency: 1
      start_interval_ms: 2000
---
