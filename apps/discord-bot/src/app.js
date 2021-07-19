const Discord = require('discord.js');
const { readdir } = require('fs');
const { join, resolve } = require('path');

class App extends Discord.Client {
    /**
     * Create a new client
     *
     * @param {Object} config
     * @param {ClientOptions} options
     */
    constructor(config, options = {}) {
        super(options);

        /**
         * Login token
         *
         * @type {string}
         */
        this.token = config.token;

        this.commands = new Discord.Collection();

        this.logger = require('./utils/logger');
    }

    loadEvents(path) {
        readdir(path, (err, files) => {
            if (err) this.logger.error(err);
            files = files.filter(f => f.split('.').pop() === 'js');
            if (files.length === 0) return this.logger.info('No events found');
            this.logger.info(`${files.length} event(s) found...`);
            files.forEach(f => {
                const eventName = f.substring(0, f.indexOf('.'));
                const event = require(resolve(__basedir, join(path, f)));
                super.on(eventName, event.bind(null, this));
                delete require.cache[require.resolve(resolve(__basedir, join(path, f)))]; // Clear cache
                this.logger.info(`Loading event: ${eventName}`);
            });
        });
        return this;
    }

    loadCommands(path) {
        readdir(path, (err, files) => {
            if (err) this.logger.error(err);
            files = files.filter(f => f.split('.').pop() === 'js');
            if (files.length === 0) return this.logger.info('No commands found')
            this.logger.info(`${files.length} command(s) found...`);

            for (const file of files) {
                const commandName = file.substring(0, file.indexOf('.'));
                const command = require(resolve(__basedir, join(path, file)));
                this.commands.set(command.name, command);
                this.logger.info(`Loading command: ${commandName}`)
            }
        })
    }
}

module.exports = App;