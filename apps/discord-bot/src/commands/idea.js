const { MessageEmbed } = require("discord.js");

module.exports = {
  name: 'idea',
  description: 'Idea!',
  async execute(client, message, args) {
    if (args.length >= 1) {
      const user = message.member.user;
      const newMessage = new MessageEmbed()
        .setColor('#0099ff')
        .setTitle(`Idée de ${user.username}`)
        .setDescription(args.join(' '))
        .setThumbnail(user.avatarURL())
        .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
        .setTimestamp()
      ;

      const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_IDEA);
      const emojis = await client.guilds.cache.first().emojis;

      const ideaMessage = await channel.send(newMessage);

      await ideaMessage.react(await emojis.cache.find((value) => value.name === "done"));
      await ideaMessage.react(await emojis.cache.find((value) => value.name === "cancelled"));
    }

    await message.delete();
  },
};