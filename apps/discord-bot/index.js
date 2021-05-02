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

server.get('/', (req, res) => {
    res.send('Everything is OK.');
});

server.post('/webhooks', async (req, res) => {
    const { event, data } = req.body

    if (!event || !data) {
        return res.json({ status: 400, errorMessage: 'bad parameter' })
    }

    switch (event) {
        case 'task.created': {
            const { url, state, content } = data
            const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_EVENT);
            const { first_name, last_name, username, avatar_url } = data.user
            const fullName = `${first_name} ${last_name} (${username})`
            const userProfileUrl = `https://www.checkmark.dev/u/${username}`

            const message = new MessageEmbed()
                .setColor(getStateColor(state))
                .setAuthor(fullName, avatar_url, userProfileUrl)
                .setTitle(`Création d\'une nouvelle tâche`)
                .setURL(url)
                .setDescription(`${getStateEmoji(state)} ${content}`)
                .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
                .setTimestamp();

            await channel.send(message)
        } break
        case 'weekly_summary.created': {
            const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_WEEKLY);
            const { metrics, user, url } = data
            const { first_name, last_name, username, avatar_url } = user
            const fullName = `${first_name} ${last_name}`
            const userProfileUrl = `https://www.checkmark.dev/u/${username}`

            const states = ['done', 'doing', 'todo']

            const imageParams = new URLSearchParams()
            imageParams.append('avatar_url', avatar_url)
            imageParams.append('week', 'Récapitulatif de la semaine')
            states.forEach(state => {
                imageParams.append(state, `${metrics[state]} ${metrics[state] === 1 ? 'tâche' : 'tâches'}`)
            })
            imageParams.append('name', fullName)
            imageParams.append('username', `@${username}`)

            let imageUrl = `https://images.socialsplash.xyz/9f1cff11-70b1-4386-a085-dda8b5d61548.jpg?`
            imageUrl += imageParams.toString()

            const message = new MessageEmbed()
                .setAuthor(`${fullName} (${username})`, avatar_url, userProfileUrl)
                .setTitle('Récapitulatif de la semaine')
                .setImage(imageUrl)
                .setURL(url)
                .setFooter('Checkmark', 'https://www.checkmark.dev/icon.png')
                .setTimestamp();

            await channel.send(message)
        } break
        case 'changelog.created': {
            const channel = await client.channels.fetch(process.env.DISCORD_CHANNEL_CHANGELOG);
            const { name, content, url, created_at } = data

            const message = new MessageEmbed()
                .setTitle(name)
                .setURL(url)
                .setDescription(content)
                .setFooter('Changelog', 'https://www.changelog.xyz/icon.png')
                .setTimestamp(Date.parse(created_at));

            await channel.send(message)
        } break
    }

    res.send('coucou');
});

server.listen(PORT, HOST, () => {
    console.log(`Discord bot started on ${HOST}:${PORT}.`)
});

process.on('unhandledRejection', err => console.log(err));
