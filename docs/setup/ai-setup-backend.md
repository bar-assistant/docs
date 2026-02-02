# AI Integration

Since version v5.13.0 Bar Assistant API supports AI integration using different AI providers (Anthropic, DeepSeek, Gemini, Mistral, Ollama, OpenAI, XAI).

Enabling AI integration unlocks the following features:

- Automatic tag suggestions for cocktail recipes. This feature is available when updating an existing recipe.
- Automatic ingredient details autocomplete based on ingredient name. This feature is available when you write at least the first 3 letters of the ingredient name.
- Extracting recipe instructions from unstructured text input.

!!! tip

    If the features are not showing after you enabled AI integration, make sure to sign out and sign back in so the client can pull the latest configuration.

## Setup

To enable AI integration, you need to set the following environment variables in your Bar Assistant API configuration:

- `GEN_AI_PROVIDER`: The AI provider you want to use. You can use any provider supported by the [PrismPHP package.](https://prismphp.com/)
- `GEN_AI_MODEL`: The specific AI model to use from the selected provider.

The rest of the configuration depends on the selected AI provider. Below are examples for some popular providers:

### Ollama
```sh
GEN_AI_PROVIDER=ollama
GEN_AI_MODEL=ministral-3
# Optional, will use http://localhost:11434 by default
OLLAMA_URL=
```

### OpenAI
```sh
GEN_AI_PROVIDER=openai
GEN_AI_MODEL=gpt-4
OPENAI_API_KEY=sk-proj-your-key
# Optional
OPENAI_URL=
OPENAI_ORGANIZATION=
```

## Anthropic
```sh
GEN_AI_PROVIDER=anthropic
GEN_AI_MODEL=claude-2
ANTHROPIC_API_KEY=
ANTHROPIC_API_VERSION=
# Optional
ANTHROPIC_DEFAULT_THINKING_BUDGET=
ANTHROPIC_BETA=
```

## Anthropic
```sh
GEN_AI_PROVIDER=deepseek
GEN_AI_MODEL=deepseek-chat
DEEPSEEK_API_KEY=
# Optional
DEEPSEEK_URL=
```

## Gemini
```sh
GEN_AI_PROVIDER=gemini
GEN_AI_MODEL=gemini-2.0-flash
GEMINI_API_KEY=
# Optional
GEMINI_URL=
```

## Mistral
```sh
GEN_AI_PROVIDER=mistral
GEN_AI_MODEL=magistral-medium-latest
MISTRAL_API_KEY=
# Optional
MISTRAL_URL=
```

## xAI
```sh
GEN_AI_PROVIDER=xai
GEN_AI_MODEL=grok-4
XAI_API_KEY=
# Optional
XAI_URL=
```

## Groq
```sh
GEN_AI_PROVIDER=groq
GEN_AI_MODEL=llama-3.3-70b-versatile
GROQ_API_KEY=
# Optional
GROQ_URL=
```
