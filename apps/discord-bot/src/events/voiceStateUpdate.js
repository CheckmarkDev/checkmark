const { VoiceChannel } = require('discord.js')

module.exports = async (client, previousVoiceState, nextVoiceState, user) => {
  const guild = previousVoiceState.guild;
  const member = previousVoiceState.member;

  // join channel
  if ((null === previousVoiceState.channelID && nextVoiceState.channelID) || (previousVoiceState.channelID && nextVoiceState.channelID && previousVoiceState.channelID !== nextVoiceState.channelID)) {
    const actualChannel = nextVoiceState.channel;
    client.logger.info(`${member.user.username} has joined channel "${actualChannel.name}"`)

    if (nextVoiceState.channelID === process.env.DISCORD_CHANNEL_CREATE_WORKING_ROOM) {
      const newChannel = await guild.channels.create(`Coworking de ${member.user.username}`, {
        type: 'voice',
        parent: actualChannel.parent,
      })
      await member.voice.setChannel(newChannel)
    }
  }

  // leave channel
  if ((previousVoiceState.channelID && null === nextVoiceState.channelID) || (previousVoiceState.channelID && nextVoiceState.channelID && previousVoiceState.channelID !== nextVoiceState.channelID)) {
    const actualChannel = previousVoiceState.channel;
    client.logger.info(`${member.user.username} has left channel "${actualChannel.name}"`);

    if (actualChannel.name.startsWith('Coworking de') && actualChannel.id !== process.env.DISCORD_CHANNEL_CREATE_WORKING_ROOM && actualChannel.members.size < 1) {
      await actualChannel.delete();
      client.logger.info(`"${actualChannel.name}" has been deleted after the last user (${member.user.username}) leave`)
    }
  }
}

