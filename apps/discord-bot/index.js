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
}, {
    partials: ['MESSAGE', 'CHANNEL', 'REACTION']
});

const init = () => {
    client.loadEvents('./src/events');
    client.login(client.token);
}

init();


// webhook
server.use(bodyParse.json({ type: 'application/json'}));

const getStateColor = (state) => {
    switch (state) {
        case 'done':
            return '#38A169'
        case 'doing':
            return '#EDAF53'
        case 'todo':
        default:
            return '#AFB6BF'
    }
}

const getStateEmoji = (state) => {
    switch (state) {
        case 'done':
            return `<:done:${process.env.DISCORD_EMOJI_DONE}>`
        case 'doing':
            return `<:doing:${process.env.DISCORD_EMOJI_DOING}>`
        case 'todo':
        default:
            return `<:todo:${process.env.DISCORD_EMOJI_TODO}>`
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
                .setColor(getStateColor(data.status))
                .setAuthor(`Par ${data.user.first_name} ${data.user.last_name} (${data.user.username})`)
                .setTitle(`Création d\'une nouvelle tâche`)
                .setURL(data.url)
                .setDescription(`${getStateEmoji(data.status)} ${data.content}`)
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