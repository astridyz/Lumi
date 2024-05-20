--// Creating session
local Lumi = require '../init'

local Session = Lumi.session() --// Session is a factory function

--// Events constants, needed to listen to events
local Events = Lumi.events


--// Authenticate your token in the Discord API,=
Session.login('TOKEN')

Session.listen(Events.messageCreate, function(message)
    local err = message.reply('Hi there!')
    --[[
        Methods that interact direct with Discord can return data and an error or just an error.
        In that case, message.reply() only returns an error

        Error handling is recommended in public bots.
        Otherwise if your bot is private and has all permissions, no need to do it.
    ]]

    assert(not err, 'Could not send message :( \nReason: ' .. err)
end)

Session.connect() --// Open gateway connection, your bot should go online now