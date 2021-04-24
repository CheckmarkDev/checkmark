const { MessageEmbed } =  require('discord.js')

module.exports = async (client, message) => {

    if (message.content.startsWith('!help')) {
        const newMessage = new MessageEmbed()
            .setColor('#0099ff')
            .setTitle('!help')
            .setDescription('help description')
            .setThumbnail('https://www.checkmark.dev/icon.png')
            .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
            .setTimestamp()
        ;

        await message.channel.send(newMessage)
    }

    if (message.content === 'ping') {
        await message.reply('Pong!');
    }
}