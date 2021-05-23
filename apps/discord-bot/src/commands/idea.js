const { MessageEmbed } = require("discord.js");

module.exports = {
  name: 'idea',
  description: 'Idea!',
  async execute(message, args) {
    if (args.length >= 1) {
      const user = message.member.user
      const newMessage = new MessageEmbed()
        .setColor('#0099ff')
        .setTitle(`Idée de ${user.username}`)
        .setDescription(args.join(' '))
        .setThumbnail(user.avatarURL())
        .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
        .setTimestamp()
      ;

      await message.channel.send(newMessage)
    }

    await message.delete();
  },
};