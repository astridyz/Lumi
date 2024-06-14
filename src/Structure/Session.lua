--!strict
--// Packages
local Component = require '../Component'
type Data = Component.Data

local Events = require '../Events'
type Event<args...> = Events.Event<args...>

local Rest = require 'API/Rest'
type Error = Rest.Error

local Shard = require 'API/Shard'
type Identify = Shard.Identify

local State = require 'State'
type State = State.State

local User = require 'Serialized/User'
type User = User.User

local Message = require 'Serialized/Message'
type Message = Message.Message

local Application = require 'Serialized/Application'
type Application = Application.Application

local Command = require 'Builders/Command'
type CommandBuilder = Command.CommandBuilder
type Command = Command.CommandBuilt

local Listen = require 'Listen'
local Serializer = require 'Serializer'
local Mutex = require 'Mutex'

--// Types
export type Session = {
    login: (token: string) -> (),
    identify: Identify,
    connect: () -> (),
    
    state: State,
    user: User,
    application: Application,

    listen: <args...>(event: Event<args...>, callback: (args...) -> ()) -> (),

    getGlobalCommands: () -> (Data?, Error),
    registerGlobalCommand: (command: CommandBuilder) -> string?,
    deleteGlobalCommand: (ID: string) -> string?,

    getGuildCommands: (guildID: string) -> (Data?, Error),
    registerGuildCommand: (guildID: string, command: CommandBuilder) -> string?,
    deleteGuildCommand: (guildID: string, ID: string) -> string?,

    replyInteraction: (interactionID: string, interactionToken: string, content: Data) -> string?,

    sendMessage: (channelID: string, content: string | Data, replyTo: string?) -> string?,
}

--[=[

    @class Session

    Main interface for interacting with Discord.

    :::info TOPOLOGICALLY-AWARE
    The session functions are only usable if called within the context of Session.login()
    :::

]=]

--// This
return Component.wrap('Session', function(self): Session
    --// Private
    local Token;
    local Shards = {}

    local API = Rest()
    local EventHandler = Listen()
    local State = State()
    local Mutex = Mutex()

    local Serializer = Serializer(self :: any, State)

    --// Public

    --[=[

        @within Session
        @prop user User

        The current bot user model.

    ]=]

    self.user = {} :: User

    --[=[

        @within Session
        @prop application Application

        The current bot application model.

    ]=]

    self.application = {} :: Application

    --[=[

        @within Session
        @prop state State

        The current state for all data in session.

    ]=]

    self.state = State

    --[=[
    
        @within Session
        @prop identify Identify

        Information useful for handshake with Discord.
        Check docs for more information about this.

    ]=]

    self.identify = {} :: Identify

    --// Methods

    --[=[

        @within Session
        @param token string

        Authenticates your token in Discord API. 
        Trying to call `Session.connect()` without a valid token 
        will throw an error.

    ]=]

    function self.login(token: string): ()
        assert(token ~= nil, 'No token has been sent.')
        Token = token

        local botUser, botApp = API.authenticate(Token)

        self.user = Serializer.data(botUser, User)
        self.application = Serializer.data(botApp, Application)
    end

    --[=[

        @within Session
        
        Connects to Discord Gateway, opening the websocket connection.  
        After calling it, your bot should go online and receive all Discord events.

    ]=]

    function self.connect()
        assert(Token ~= nil, 'No token available, authenticate first.')

        local Data, err = API.getGatewayBot()
        assert(Data ~= nil and err == nil, 'Could not authenticate: ' .. tostring(err and err.message))

        for shardID = 1, Data.shards do
            local shard = Shard(Token, EventHandler, Serializer, Mutex)
            Shards[shardID] = shard

            coroutine.wrap(shard.bind)(shardID - 1, Data.shards, Data.url, self.identify)
            shard.waitForHandshake()
        end

    end

    --[=[

        @within Session
        @param event {} -- An event object. All events are listed in `Events.lua` file.

        Listen to a given `Event` and calls a callback when it is emitted.
        
        ### Usage Example:

        ```lua
        Session.listen(Events.messageCreate, function(message)
            print(message.author.ID)
        end)
        ```

    ]=]

    function self.listen<args...>(event: Event<args...>, callback: (args...) -> ()): ()
        assert(Events[event.index], 'Invalid event type')
        
        return EventHandler.listen(event.name, callback)
    end

    --[=[

        @within Session

        Return a table with all the global current commands your bot has.

        @return (data: {}?, error: string?)

    ]=]

    function self.getGlobalCommands()
        local data, err = API.getAllGlobalApplicationCommands()
        return data, err
    end

    --[=[

        @within Session
        @param command CommandBuilder -- A builder object created by Lumi builders.

        Register a global application command in your BOT.

        @return (error: string?)

    ]=]

    function self.registerGlobalCommand(command: CommandBuilder): string?
        local data = command.get()

        local _, err = API.createGlobalApplicationCommand(data)
        return err and err.message
    end

    --[=[

        @within Session
        @param ID string

        Delete a global application command in your BOT.

        @return (error: string?)

    ]=]

    function self.deleteGlobalCommand(ID: string): string?
        local _, err = API.deleteGlobalApplicationCommand(ID)
        return err and err.message
    end

    --[=[

        @within Session

        Returns a table of commands registred in the defined guild.

        @return (data: {}?, error: string?)

    ]=]

    function self.getGuildCommands(guildID: string)
        local data, err = API.getAllGuildApplicationCommands(guildID)
        return data, err
    end

    --[=[

        @within Session
        @param guildID string
        @param command CommandBuilder -- A builder object created by Lumi builders.

        Register a guild-only application command in your BOT.

        @return (error: string?)

    ]=]

    function self.registerGuildCommand(guildID: string, command: CommandBuilder): string?
        local data = command.get()

        local _, err = API.createGuildApplicationCommand(guildID, data)
        return err and err.message
    end

    --[=[

        @within Session
        @param ID string

        @return (error: string?)

    ]=]

    function self.deleteGuildCommand(guildID: string, ID: string)
        local _, err = API.deleteGuildApplicationCommand(guildID, ID)
        return err and err.message
    end

    --[=[

        @within Session
        @param interactionID string
        @param token string
        @param data {} | string

        Send a response to an interaction.

        ::info Topologically-aware
        This function is only usable if called within the context of Session.connect()
        :::

        @return (error: string?)

    ]=]

    function self.replyInteraction(interactionID: string, token: string, data: Data | string)
        local payload = {}
        payload.data = {content = data}
        payload.type = 4

        local _, err = API.createInteractionResponse(interactionID, token, payload)

        return err and err.message
    end

    --[=[

        @within Session
        @param channelID string
        @param data {} | string
        @param replyTo string?

        Sends a message in the given channel.  
        The content table needs to be created using builders available in Lumi.

        @return (error: string?) 

        ::info Topologically-aware
        This function is only usable if called within the context of Session.connect()
        :::

    ]=]

    function self.sendMessage(channelID: string, data: string | Data, replyTo: string?): (string?)
        local payload = type(data) == 'table' and {content = data.content} or {content = data} :: any

        if replyTo then
            payload.message_reference = {message_id = replyTo}
        end

        local _, error = API.createMessage(channelID, payload)
        return error and error.message
    end

    return self
end)
