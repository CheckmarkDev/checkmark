# API

### Authentication

Users can register to Checkmark with an e-mail/password combinaison. The API will generate a JWT token for that user. This token will be stored in the `tokens` table for revokation.

### REST API

There is a REST API that is used by the `www` app. Some endpoints are not being actively used since we progressively migrated to GraphQL.

You can see the endpoints with apipie under `http://localhost:3000/apipie`.

### GraphQL endpoint

In addition of the REST API, we have a GraphQL endpoint with "graphql-ruby" exposed in `http://localhost:3000/graphql`.

### Sidekiq

Sidekiq is used as our worker. It's purpose is to handle jobs (e.g. sending emails, sending webhook events to the Discord Bot).

### Webhooks

The API exposes an endpoint used for webhooks, mainly used for our Github integration. This could be extended to be used with other apps.

### E-mails

Mails are written in MJML. When Rails tries to send the e-mail, it will convert the MJML template to HTML through the `mjml` service (https://github.com/chronotruck/mjml2html). See the interceptor at `lib/mjml_email_interceptor.rb`.

If you would like to test your e-mails locally, there is a mail client running locally with MailCatcher exposed at `http://localhost:1080/`.

## Linting

The Ruby code base is linted with Rubocop. See the Rubocop config file at `.rubocop.yml`.

## Tests

There is no unit test nor integration tests currently in the code base. The test files present are auto-generated code.
