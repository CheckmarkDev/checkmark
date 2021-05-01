const roles = [
  {
    "messageIdEnvName": "DISCORD_MESSAGE_ROLE_1",
    "title": "Communauté",
    "description": "Choix des centre d\'intérêts de la communauté",
    "fields": []
  },
  {
      "messageIdEnvName": "DISCORD_MESSAGE_ROLE_2",
      "title": "Projet",
      "description": "Choix des centre d\'intérêts des différents projets",
      "fields": []
  },
  {
    "messageIdEnvName": "DISCORD_MESSAGE_ROLE_3",
    "title": "Développement",
    "description": "Choix des centre d\'intérêts des différents langages de programmation",
    "fields": [
      {
        "name": "Réactions",
        "value": [
            `<:html:${process.env.DISCORD_EMOJI_HTML}>`,
            `<:javascript:${process.env.DISCORD_EMOJI_JAVASCRIPT}>`,
            `<:php:${process.env.DISCORD_EMOJI_PHP}>`,
            `<:python:${process.env.DISCORD_EMOJI_PYTHON}>`,
            `<:java:${process.env.DISCORD_EMOJI_JAVA}>`,
            `<:golang:${process.env.DISCORD_EMOJI_GO}>`,
            `<:ccpp:${process.env.DISCORD_EMOJI_C}>`,
            `<:csharp:${process.env.DISCORD_EMOJI_CSHARP}>`,
            `<:docker:${process.env.DISCORD_EMOJI_DOCKER}>`,
            `<:hardware:${process.env.DISCORD_EMOJI_HARDWARE}>`,
            `<:database:${process.env.DISCORD_EMOJI_DATABASE}>`,
            `<:security:${process.env.DISCORD_EMOJI_SECURITY}>`
        ],
        "inline": true
      },
      {
        "name": "Salons",
        "value": [
            `<#${process.env.DISCORD_CHANNEL_HTML}>`,
            `<#${process.env.DISCORD_CHANNEL_JAVASCRIPT}>`,
            `<#${process.env.DISCORD_CHANNEL_PHP}>`,
            `<#${process.env.DISCORD_CHANNEL_PYTHON}>`,
            `<#${process.env.DISCORD_CHANNEL_JAVA}>`,
            `<#${process.env.DISCORD_CHANNEL_GO}>`,
            `<#${process.env.DISCORD_CHANNEL_C}>`,
            `<#${process.env.DISCORD_CHANNEL_CSHARP}>`,
            `<#${process.env.DISCORD_CHANNEL_DOCKER}>`,
            `<#${process.env.DISCORD_CHANNEL_HARDWARE}>`,
            `<#${process.env.DISCORD_CHANNEL_DATABASE}>`,
            `<#${process.env.DISCORD_CHANNEL_SECURITY}>`,
        ],
        "inline": true
      }
    ]
  },
  {
      "messageIdEnvName": "DISCORD_MESSAGE_ROLE_4",
      "title": "Développement de jeux video",
      "description": "Choix des centre d\'intérêts des différents développement dans le monde du jeux video",
      "fields": []
  },
  {
      "messageIdEnvName": "DISCORD_MESSAGE_ROLE_5",
      "title": "Loisir",
      "description": "Choix des centre d\'intérêts des différents loisirs",
      "fields": []
  },
];

module.exports = { roles };
