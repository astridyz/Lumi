--// Creating session
local Lumi = require '../init'

--// Session is a factory function
local Session = Lumi.session()

--// Authenticate your token in the Discord API
Session.login('TOKEN')

--// Enum is a module handling all Discord flags and information.
local Enum = Lumi.enums

--// Get the intents from Enum
local Intents = Enum.gatewayIntents

--// Identify is a payload that Discord requests to authenticate your user when connecting to the gateway.
--// To change the intents, we will change the intent array before opening the connection.
Session.identify.intents = {
    --// Add the intents to the array
    Intents.guildMembers,
    Intents.guildPresences,
    Intents.messageContent
}

--// Simply open the connection, the array will be send directly to Discord.
Session.connect()