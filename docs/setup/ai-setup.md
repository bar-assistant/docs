# AI Integration

Since version v4.7.0 Salt Rim client supports Ollama server for added AI features.

Enabled features:

- Automatic tagging for cocktail recipes
- Automatic ingredient details suggestions (description, origin, color...)

More features can be suggested by opening a [GitHub issue](https://github.com/karlomikus/vue-salt-rim/issues).

## Enabling Ollama

To enable Ollama integration, you need to setup the provider, correct host and what model to use via **salt-rim** environment variables.

```properties
AI_PROVIDER=
AI_HOST=
AI_MODEL=
```

Keep in mind that you need to [properly configure Ollama](https://github.com/ollama/ollama/blob/main/docs/faq.md#how-do-i-configure-ollama-server) if you are serving it on a different host. Here's an example.

```yaml title="docker-compose.yml"
salt-rim:
    environment:
        - AI_PROVIDER=ollama
        - AI_HOST=https://llm.barassistant.app
        - AI_MODEL=gemma3
```

## Supported providers

Currently the only provider supported is `ollama`.
