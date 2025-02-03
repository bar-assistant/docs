# Mail setup

Since version v3.3.0 Bar Assistant can send emails if you have the correct configuration. This is not required but enables a few features like:

- Request users to verify their email before allowing them to authenticate
- Sending password forgot and reset emails

## Docker setup

Bar Assistant supports the following drivers:

- Log driver - Sends emails to a log file. Setup by setting the ENV variable `MAIL_MAILER=log`. No other configuration is needed.
- SMTP driver - Sends emails via SMTP server. Setup by setting the ENV variable `MAIL_MAILER=smtp`.

To enable email sending via SMTP you need to setup the following ENV variables:

```properties title="Example .env with SMTP configuration"
MAIL_MAILER=smtp
# SMTP hostname
MAIL_HOST=smtp.myserver.com
# SMTP port
MAIL_PORT=2525
# SMTP encryption
MAIL_ENCRYPTION=tls
# SMTP username
MAIL_USERNAME=mailuser
# SMTP password
MAIL_PASSWORD=mailpassword
```

And the following ENV variables on salt-rim:

```properties title="Salt Rim client .env"
MAILS_ENABLED=true
```

The rest of the variables that are related are the following:

- `MAIL_REQUIRE_CONFIRMATION=true` - Enabling this will require users to confirm email before being able to authenticate. (Default: `false`).
- `MAIL_CONFIRM_URL="https://your-frontend.url/confirmation/[id]/[hash]"` - URL that handles email confirmation on your frontend/client. This is the URL that gets sent in the email. The `[id]` and `[hash]` placeholders gets replaced with the user ID and confirmation hash. (Default: `""`).
- `MAIL_RESET_URL="https://your-frontend.url/reset-password?token=[token]"` - URL that handles password reset on your frontend/client. This is the URL that gets sent in the email. The `[token]` placeholder gets replaced with the actual reset password token. (Default: `""`).
- `MAIL_FROM_ADDRESS="no-reply@barassistant.app"` - Email from address. (Default: `""`).
- `MAIL_FROM_NAME="Bar Assistant"` - Email from name. (Default: `""`).

