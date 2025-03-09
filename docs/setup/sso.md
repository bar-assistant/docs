# SSO / OAuth setup

Since version v5.0.0 Bar Assistant has support for Single Sign On (SSO).

Bar Assistant currently supports the following SSO providers:

- Google
- GitHub
- GitLab
- Authelia
- Authentik
- Keycloak

More SSO providers can be implmented by opening a [GitHub issue](https://github.com/karlomikus/bar-assistant/issues).

## Enabling providers

To enable SSO you need to set the following ENV variables depending on the provider you want to use.

```properties title=".env"
# To enable Google set the following:
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_REDIRECT_URI=

# To enable GitHub set the following:
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
GITHUB_REDIRECT_URI=

# To enable GitLab set the following:
GITLAB_CLIENT_ID=
GITLAB_CLIENT_SECRET=
GITLAB_REDIRECT_URI=

# To enable Authentik set the following:
AUTHENTIK_BASE_URL=
AUTHENTIK_CLIENT_ID=
AUTHENTIK_CLIENT_SECRET=
AUTHENTIK_REDIRECT_URI=

# To enable Authelia set the following:
AUTHELIA_BASE_URL=
AUTHELIA_CLIENT_ID=
AUTHELIA_CLIENT_SECRET=
AUTHELIA_REDIRECT_URI=

# # To enable Keycloak set the following:
KEYCLOAK_CLIENT_ID=
KEYCLOAK_CLIENT_SECRET=
KEYCLOAK_REDIRECT_URI=
KEYCLOAK_BASE_URL=
KEYCLOAK_REALM=
```

Here's an example of how to enable Authentik SSO:

```yaml title="docker-compose.yml"
bar-assistant:
    environment:
        - AUTHENTIK_BASE_URL=https://your-autentik.instance.com
        - AUTHENTIK_CLIENT_ID=jYIXGY9QhEUWMpOCxo62wIwnOOKA32378MvtqZSA
        - AUTHENTIK_CLIENT_SECRET=Fe2q5Zkjb1xK3eM0tSgMUu8P72bKniGTcygxDVmM2UQcThY9GZhY8UYsaywk9bSkadlADVjU7Aj1aRkKqKyB1ASaaMNXPexlrr40zWxyvJIN4eMxcUvuVYvYX9iG9qt
        - AUTHENTIK_REDIRECT_URI=https://mybar.local.com/oauth/callback
```

!!! warning

    Your redirect URI must be accessible from your browser. If you're using Salt Rim, set it to `{your-domain}/oauth/callback`.

## SSO Management

Users are identified by their email address. If you already have an account, signing in via SSO will automatically link it to your existing account. You can view linked accounts on your profile page. If a new user signs in via SSO and doesn't have an account, one will be created automatically.