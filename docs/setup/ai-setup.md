# AI Integration

Since version v4.7.0 Salt Rim client supports generative AI features.

Enabled features:

- Automatic tag creation for cocktail recipes
- Automatic ingredient details suggestions (description, origin, color...)

More features can be suggested by opening a [GitHub issue](https://github.com/karlomikus/vue-salt-rim/issues).

## Supported providers

To use AI features in Salt Rim, you need to set up an AI provider. Currently the supported providers include:

- [Ollama](https://ollama.com/) via `ollama` provider settings
    - Keep in mind that you need to [properly configure Ollama](https://github.com/ollama/ollama/blob/main/docs/faq.md#how-do-i-configure-ollama-server).
- [LM Studio](https://lmstudio.ai/) via `lmstudio` provider settings

Unsupported providers will fallback to openai compatibile API.

!!! warning

    Keep in mind that the AI integration setup is currently client side only and will be available to all accounts. We recommend that you only enable AI features if your are self hosting on your local network.

To enable AI integration, you need to setup **salt-rim** environment variables. Here's an example of how to set them up in a default compose file:

```yaml title="docker-compose.yml"
salt-rim:
    environment:
      - AI_PROVIDER="ollama"
      - AI_HOST="http://localhost:11434"
      - AI_MODEL="gemma3"
      - AI_API_KEY="add-if-required"
```

When you're done with the setup, you can visit your Salt Rim instance and check if the AI features are enabled. You can do that on the following pages:

- Cocktail edit/create form page:
    - AI generate button will show up in the tags input field after you fill some basic information about the cocktail.
- Ingredient edit/create form page:
    - AI generate button will show up in the name input field after you fill in the name of the ingredient.
