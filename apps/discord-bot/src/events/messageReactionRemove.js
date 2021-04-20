
module.exports = async (client, reaction, user) => {
    if (user.bot) {
        return;
    }

    try {
        await reaction.fetch();
    } catch (e) {
        console.log(e);
    }

    // add role basic user if u click on check emoji
    if (reaction.emoji.name === '✅' && process.env.DISCORD_MESSAGE_RULES === reaction.message.id) {
        const member = await reaction.message.guild.members.fetch(user);

        await member.roles.remove(process.env.DISCORD_ROLES_USER);
    }
}