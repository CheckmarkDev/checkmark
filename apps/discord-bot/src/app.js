const Discord = require('discord.js');
const { readdir } = require('fs');
const { join, resolve } = require('path');

class App extends Discord.Client {
    constructor(config, options = {}) {
        super(options);

        this.token = config.token;
    }

    loadEvents(path) {
        readdir(path, (err, files) => {
            if (err) console.log(err);
            files = files.filter(f => f.split('.').pop() === 'js');
            if (files.length === 0) return console.log('No events found');
            console.log(`${files.length} event(s) found...`);
            files.forEach(f => {
                const eventName = f.substring(0, f.indexOf('.'));
                const event = require(resolve(__basedir, join(path, f)));
                super.on(eventName, event.bind(null, this));
                delete require.cache[require.resolve(resolve(__basedir, join(path, f)))]; // Clear cache
                console.log(`Loading event: ${eventName}`);
            });
        });
        return this;
    }
}

module.exports = App;