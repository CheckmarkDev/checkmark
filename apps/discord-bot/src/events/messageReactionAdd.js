const { reactionPermissions } = require('../data/reactionPermissions');

module.exports = async (client, reaction, user) => {
    if (user.bot) {
        return;
    }

    try {
        await reaction.fetch();
    } catch (e) {
        console.log(e);
    }

    for (const reactionPermission of reactionPermissions) {
        if (reactionPermission.reactionName === reaction.emoji.name && reactionPermission.messageValidation === reaction.message.id) {
            const member = await reaction.message.guild.members.fetch(user)

            await member.roles.add(reactionPermission.userPermission)

            if (reactionPermission.addCustomAction) {
                await reactionPermission.addCustomAction(reaction, member)
            }
        }
    }

    if ('cancelled' === reaction.emoji.name && process.env.DISCORD_MESSAGE_RULES === reaction.message.id) {
        const member = await reaction.message.guild.members.fetch(user);

        await reaction.users.remove(user);
        await member.kick();
    }
}
