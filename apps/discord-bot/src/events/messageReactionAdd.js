
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
    if ('done' === reaction.emoji.name && process.env.DISCORD_MESSAGE_RULES === reaction.message.id) {
        const member = await reaction.message.guild.members.fetch(user);

        await member.roles.add(process.env.DISCORD_ROLES_USER);
    }

    if ('cancelled' === reaction.emoji.name && process.env.DISCORD_MESSAGE_RULES === reaction.message.id) {
        const member = await reaction.message.guild.members.fetch(user);

        await reaction.users.remove(user);
        await member.kick();
    }
}