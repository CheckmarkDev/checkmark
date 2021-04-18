const dotenv = require('dotenv').config();
const { Client, MessageEmbed } = require('discord.js');
const client = new Client();
const express = require('express');
const bodyParse = require('body-parser');
const app = express();

app.use(bodyParse.json({ type: 'application/json'}));

const getStatusColor = (status) => {
    switch (status) {
        default:
        case 'todo':
            return '#AFB6BF'
        case 'pending':
            return '#EDAF53'
        case 'done':
            return '#38A169'
    }
}

app.post('/webhooks', async (req, res) => {
    const { body } = req;

    if (!body.event || !body.data) {
        return res.json({ status: 400, errorMessage: 'bad parameter' })
    }

    const { event, data } = body;

    switch (event) {
        case 'task.created':
            const newMessage = new MessageEmbed()
                .setColor(getStatusColor(data.status))
                .setAuthor(`Par ${data.user.username}`)
                .setTitle(`Création d\'une nouvelle tache`)
                .setURL(data.url)
                .setDescription(data.content)
                .setThumbnail(data.user.avatar_url)
                .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
                .setTimestamp();
            const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_EVENT);
            await channel.send(newMessage)
            break
    }

    res.send('coucou');
});

client.on('ready', async () => {
    console.log(`Logged in as ${client.user.tag}!`);

    await client.user.setPresence({
        activity: {
            type: 'PLAYING',
            name: 'construire le futur',
        },
        status: 'online'
    })
});

client.on('message', async message => {
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
});

client.login(process.env.DISCORD_API_TOKEN);

app.listen(9090, () => {
    console.log('Started express');
});