const prefix = '!';

module.exports = async (client, message) => {
    if (!message.content.startsWith(prefix) || message.author.bot) return;

    const args = message.content.slice(prefix.length).trim().split(/ +/);
    const command = args.shift().toLowerCase();

    if (!client.commands.has(command)) return;

    try {
        await client.commands.get(command).execute(message, args);
    } catch (error) {
        this.logger.error(error);
        message.reply('there was an error trying to execute that command!');
    }
}