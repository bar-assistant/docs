# AI Integration

Bar Assistant supports AI-powered features since API version v5.13.0. AI runs on the [Laravel AI SDK](https://laravel.com/docs/ai-sdk) and is configured on the Bar Assistant API, not in the Salt Rim web client.

Enabling AI integration unlocks the following features:

- Automatic tag suggestions for cocktail recipes. This feature is available when updating an existing recipe.
- Automatic ingredient details autocomplete based on the ingredient name. This feature is available when you enter at least the first 3 characters of the name.
- Extracting a structured cocktail recipe from unstructured text input.
- Generating cocktail images using an image-capable AI provider.

AI features are enabled instance-wide and are available to all accounts on that instance. Provider credentials stay on the server and are never exposed to clients.

!!! tip

    After changing AI environment variables, restart the API container (or run `php artisan config:clear` when caching configuration) so the new values are picked up. If the AI buttons are still missing in Salt Rim, sign out and sign back in so the client refreshes the server configuration.

## Setup

At minimum, configure a text generation provider on the Bar Assistant API:

| Variable | Required | Description |
|----------|----------|-------------|
| `GEN_AI_PROVIDER` | Yes | AI provider to use for text generation. See the [supported providers](#supported-providers) table. |
| `GEN_AI_MODEL` | No | Specific model to use. When omitted, the provider's default model is used. Required for `openai-compatible` providers. |

Depending on the provider, you also need to set its API key and, optionally, a custom API URL.

### Image generation

Cocktail image generation is optional and requires an image-capable provider:

| Variable | Required | Description |
|----------|----------|-------------|
| `GEN_AI_IMAGE_PROVIDER` | Yes, for images | Image-capable provider. Supported values: `openai`, `gemini`, `xai`, `openrouter`, `azure`, `bedrock`. |
| `GEN_AI_IMAGE_MODEL` | No | Specific image model to use. When omitted, the provider's default image model is used. |

Image generation is only available when both `GEN_AI_PROVIDER` and `GEN_AI_IMAGE_PROVIDER` are set.

## Supported providers

| Provider | `GEN_AI_PROVIDER` | Credentials and options | Images |
|----------|-------------------|-------------------------|--------|
| Ollama | `ollama` | `OLLAMA_URL` (default `http://localhost:11434`), optional `OLLAMA_API_KEY` | No |
| LM Studio / OpenAI-compatible | `openai-compatible` | `OPENAI_COMPATIBLE_URL`, optional `OPENAI_COMPATIBLE_API_KEY`; `GEN_AI_MODEL` is required | No |
| OpenAI | `openai` | `OPENAI_API_KEY`, optional `OPENAI_URL` | Yes |
| Anthropic | `anthropic` | `ANTHROPIC_API_KEY`, optional `ANTHROPIC_URL` | No |
| Gemini | `gemini` | `GEMINI_API_KEY`, optional `GEMINI_URL` | Yes |
| DeepSeek | `deepseek` | `DEEPSEEK_API_KEY` | No |
| Mistral | `mistral` | `MISTRAL_API_KEY` | No |
| xAI | `xai` | `XAI_API_KEY` | Yes |
| Groq | `groq` | `GROQ_API_KEY` | No |
| OpenRouter | `openrouter` | `OPENROUTER_API_KEY` | Yes |
| Azure OpenAI | `azure` | `AZURE_OPENAI_API_KEY`, `AZURE_OPENAI_URL`, `AZURE_OPENAI_DEPLOYMENT` | Yes |
| Amazon Bedrock | `bedrock` | `AWS_BEDROCK_REGION` and either `AWS_BEARER_TOKEN_BEDROCK` or `AWS_ACCESS_KEY_ID` + `AWS_SECRET_ACCESS_KEY` | Yes |

The selected model needs to support structured output (JSON schema), since recipe, tag, and ingredient generation rely on structured responses. If a model or provider does not support structured output, those endpoints will return an error.

### Ollama

```sh
GEN_AI_PROVIDER=ollama
GEN_AI_MODEL=qwen3.5:4b
# Optional, this is the default
OLLAMA_URL=http://localhost:11434
```

!!! note

    If the API runs in Docker, `localhost` refers to the container itself. Use `http://host.docker.internal:11434` (or your Ollama service name) to reach an Ollama instance running on the host.

### OpenAI

```sh
GEN_AI_PROVIDER=openai
GEN_AI_MODEL=gpt-6.1-sol
OPENAI_API_KEY=sk-your-key
# Optional
OPENAI_URL=https://api.openai.com/v1
```

To enable image generation with OpenAI:

```sh
GEN_AI_IMAGE_PROVIDER=openai
GEN_AI_IMAGE_MODEL=gpt-image-2.5-flare
```

### OpenAI-compatible (LM Studio, vLLM, LocalAI...)

`openai-compatible` has no default model, so `GEN_AI_MODEL` is required.

```sh
GEN_AI_PROVIDER=openai-compatible
GEN_AI_MODEL=qwen/qwen3-8b
OPENAI_COMPATIBLE_URL=http://localhost:1234/v1
OPENAI_COMPATIBLE_API_KEY=lm-studio
```

### Anthropic

```sh
GEN_AI_PROVIDER=anthropic
GEN_AI_MODEL=claude-sonnet-5-5
ANTHROPIC_API_KEY=your-key
# Optional
ANTHROPIC_URL=https://api.anthropic.com/v1
```

### Gemini

```sh
GEN_AI_PROVIDER=gemini
GEN_AI_MODEL=gemini-3.8-flash
GEMINI_API_KEY=your-key
```

To enable image generation with Gemini:

```sh
GEN_AI_IMAGE_PROVIDER=gemini
GEN_AI_IMAGE_MODEL=gemini-3.1-flash-image
```

### DeepSeek

```sh
GEN_AI_PROVIDER=deepseek
GEN_AI_MODEL=deepseek-flash
DEEPSEEK_API_KEY=your-key
```

### Mistral

```sh
GEN_AI_PROVIDER=mistral
GEN_AI_MODEL=mistral-large-2512
MISTRAL_API_KEY=your-key
```

### xAI

```sh
GEN_AI_PROVIDER=xai
GEN_AI_MODEL=grok-4.7
XAI_API_KEY=your-key
```

### Groq

```sh
GEN_AI_PROVIDER=groq
GEN_AI_MODEL=openai/gpt-oss-120b
GROQ_API_KEY=your-key
```

### OpenRouter

```sh
GEN_AI_PROVIDER=openrouter
GEN_AI_MODEL=anthropic/claude-sonnet-5.5
OPENROUTER_API_KEY=your-key
```

### Docker Compose example

```yaml title="docker-compose.yml"
bar-assistant:
    environment:
      - GEN_AI_PROVIDER=ollama
      - GEN_AI_MODEL=qwen3.5:4b
      - OLLAMA_URL=http://host.docker.internal:11434
```

## Verify the setup

Once the API is restarted, visit your Salt Rim instance and check that the AI features are available:

- Cocktail create/edit form: an AI generate button appears in the tags input for existing cocktails.
- Cocktail edit form: a generate image button appears in the image section for existing cocktails.
- Cocktail details: a generate image action is available in the cocktail actions.
- Ingredient create/edit form: an AI generate button appears in the name input after entering at least 3 characters.
- Cocktail import: the "Import from text" option uses AI to parse an unstructured recipe.

The client reads the `is_ai_enabled` and `is_ai_image_enabled` flags from the API server status endpoint, so no AI configuration is needed in Salt Rim itself.
