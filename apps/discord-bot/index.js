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
    const { event, data } = req.body

    if (!event || !data) {
        return res.json({ status: 400, errorMessage: 'bad parameter' })
    }

    const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_EVENT);
    let message

    const { first_name, last_name, username, avatar_url } = data.user
    const fullName = `${first_name} ${last_name} (${username})`
    const userProfileUrl = `https://www.checkmark.dev/u/${username}`

    switch (event) {
        case 'task.created':
            const { url, state, content } = data

            message = new MessageEmbed()
                .setColor(getStateColor(state))
                .setAuthor(fullName, avatar_url, userProfileUrl)
                .setTitle(`Création d\'une nouvelle tâche`)
                .setURL(url)
                .setDescription(`${getStateEmoji(state)} ${content}`)
                .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
                .setTimestamp();

            await channel.send(message)
            break
        case 'weekly_summary':
            message = new MessageEmbed()
                .setAuthor(fullName, avatar_url, userProfileUrl)
                .setTitle(`Résumé de la semaine`)
                .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
                .setTimestamp();

            await channel.send(message)
            break
    }

    res.send('coucou');
});

server.post('/webhooks/changelog', async (req, res) => {
    const { event, data } = req.body

    if (!event || !data) {
        return res.json({ status: 400, errorMessage: 'bad parameter' })
    }

    const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_CHANGELOG);
    let message

    switch (event) {
        case 'changelog.created':
            const { name, content } = data

            message = new MessageEmbed()
                .setTitle(`Nouvelle release : ${name}`)
                .setURL('https://www.changelog.xyz')
                .setDescription(content)
                .setFooter('Changelog', 'https://www.checkmark.dev/icon.png')
                .setTimestamp();

            await channel.send(message)
            break
    }

    res.send('coucou');
});

server.listen(PORT, HOST, () => console.log('Started express'));



process.on('unhandledRejection', err => console.log(err));