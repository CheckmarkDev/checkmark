module.exports = async (client) => {
    console.log('ready event');
    console.log(`Logged in as ${client.user.tag}!`);

    await client.user.setPresence({
        activity: {
            type: 'PLAYING',
            name: 'construire le futur',
        },
        status: 'online'
    })
}