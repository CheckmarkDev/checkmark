const reactionPermissions = [
  {
    reactionName: 'done',
    messageValidation: process.env.DISCORD_MESSAGE_RULES,
    userPermission: process.env.DISCORD_ROLES_USER,
  },
  {
    reactionName: 'docker',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_DOCKER,
  },
  {
    reactionName: 'csharp',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_CSHARP,
  },
  {
    reactionName: 'go',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_GO,
  },
  {
    reactionName: 'cpp',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_C,
  },
  {
    reactionName: 'java',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_JAVA,
  },
  {
    reactionName: 'html',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_HTML,
  },
  {
    reactionName: 'javascript',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_JAVASCRIPT,
  },
  {
    reactionName: 'python',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_PYTHON,
  },
  {
    reactionName: 'php',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_PHP,
  },
  {
    reactionName: 'hardware',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_HARDWARE,
  },
  {
    reactionName: 'database',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_DATABASE,
  },
  {
    reactionName: 'security',
    messageValidation: process.env.DISCORD_MESSAGE_ROLE_3,
    userPermission: process.env.DISCORD_ROLES_SECURITY,
  },
]

module.exports = { reactionPermissions }
