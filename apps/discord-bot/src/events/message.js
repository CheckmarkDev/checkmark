module.exports = async (client, message) => {
    console.log('message event');

    if (message.content.startsWith('!help')) {
        const newMessage = new MessageEmbed()
            .setColor('#0099ff')
            .setTitle('!help')
            .setDescription('help description')
            .setThumbnail('https://www.checkmark.dev/icon.png')
            .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
            .setTimestamp()
        ;

        message.channel.send(newMessage)
    }

    if (message.content === 'ping') {
        await message.reply('Pong!');
    }
}