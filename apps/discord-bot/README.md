# Discord Bot

## Setup

To run the Discord bot locally, you'll need a token for the bot to use. You can get one by creating a bot account on Discord. Once you have the token, replace in the `.env` file the `DISCORD_API_TOKEN` value then restart the service.

## Webhook

This bot exposes an endpoint under the `bot.checkmark.dev` domain to be able to receive events from the platform.
It will then dispatch the messages in their appropriate channel.
