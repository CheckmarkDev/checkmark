const dotenv = require('dotenv').config();
const { MessageEmbed } = require('discord.js');
const express = require('express');
const bodyParse = require('body-parser');
const App = require('./src/app');

const server = express();

global.__basedir = __dirname;

const PORT = process.env.PORT || 9090
const HOST = process.env.HOST || 'localhost'

const client = new App({
    token: process.env.DISCORD_API_TOKEN,
});

const init = () => {
    client.loadEvents('./src/events');
    client.login(client.token);
}

init();


// webhook
server.use(bodyParse.json({ type: 'application/json'}));

const getStatusColor = (status) => {
    switch (status) {
        default:
        case 'todo':
            return '#AFB6BF'
        case 'doing':
            return '#EDAF53'
        case 'done':
            return '#38A169'
    }
}

server.post('/webhooks', async (req, res) => {
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

server.listen(PORT, HOST, () => console.log('Started express'));



process.on('unhandledRejection', err => console.log(err));