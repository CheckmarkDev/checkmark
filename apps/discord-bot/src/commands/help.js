const { MessageEmbed } = require("discord.js");

module.exports = {
  name: 'help',
  description: 'Help!',
  async execute(message, args) {
    const newMessage = new MessageEmbed()
      .setColor('#0099ff')
      .setTitle('!help')
      .setDescription('Liste de toutes les commandes disponible !\n\n\n\n')
      .addFields([
        {
          "name": "Commande",
          "value": [
            "!idea",
          ],
          "inline": true
        },
        {
          "name": "Description",
          "value": [
            "Permet de proposer une nouvelle idée à la communauté",
          ],
          "inline": true
        }
      ])
      .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
      .setTimestamp()
    ;

    await message.channel.send(newMessage)
    await message.delete();
  },
};