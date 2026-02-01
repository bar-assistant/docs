# AI Integration

Since version v5.13.0 Bar Assistant API supports AI integration using different AI providers (Anthropic, DeepSeek, Gemini, Mistral, Ollama, OpenAI, XAI).

Enabling AI integration unlocks the following features:
- Automatic tag suggestions for cocktail recipes
- Automatic ingredient details autocomplete based on ingredient name
- Extracting recipe instructions from unstructured text input

## Setup

To enable AI integration, you need to set the following environment variables in your Bar Assistant API configuration:

- `GEN_AI_PROVIDER`: The AI provider you want to use. You can use any provider supported by [PrismPHP package.](https://prismphp.com/)
- `GEN_AI_MODEL`: The specific AI model to use from the selected provider.

The rest of the configuration depends on the selected AI provider. Below are examples for some popular providers:

```
# Ollama setup:
GEN_AI_PROVIDER=ollama
GEN_AI_MODEL=ministral-3
# Optional, will use http://localhost:11434 by default
OLLAMA_URL=

# OpenAI setup:
GEN_AI_PROVIDER=openai
GEN_AI_MODEL=gpt-4
OPENAI_API_KEY=sk-proj-your-key
# Optional
OPENAI_ORGANIZATION=

# Anthropic setup:
GEN_AI_PROVIDER=anthropic
GEN_AI_MODEL=claude-2
ANTHROPIC_API_KEY=
ANTHROPIC_API_VERSION=
```
