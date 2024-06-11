--// Creating session
local Lumi = require '../init'

--// Session is a factory function
local Session = Lumi.session()

--// Events constants, needed to listen to events
local Events = Lumi.events

--// Authenticate your token in the Discord API
Session.login('TOKEN')

Session.listen(Events.messageCreate, function(message)
    --// Methods that interact direct with Discord can return data and an error or just an error.
    local err = message.reply('Hi there!')

    --//In that case, message.reply() only returns an error
    assert(not err, 'Could not send message :( \nReason: ' .. err)

    --// Error handling is recommended in public bots.
    --// Otherwise, if your bot is private, has all permissions
    --// and you think there's no need to do it, go for it.
end)

--// Open gateway connection, your bot should go online now
Session.connect()