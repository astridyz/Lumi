--!strict
--// Requires
local Lumi = require '../Lumi'
local Events = require '../Events'

local task = require '@lune/task'

local Rest = require 'API/Rest'
local Shard = require 'API/Shard'
local Listen = require 'Listen'
local Serializer = require 'Serializer'
local State = require 'State'
local Mutex = require 'Mutex'

local User = require 'Serialized/User'
local Message = require 'Serialized/Message'
local Application = require 'Serialized/Application'

--// Types
type Error = Rest.Error

type Data = Lumi.Data
type Event<args...> = Events.Event<args...>

type State = State.State
type User = User.User
type Message = Message.Message
type Application = Application.Application

type Identify = Shard.Identify

export type Session = {
    login: (token: string) -> (),
    identify: Identify,
    connect: () -> string?,
    
    state: State,
    user: User,
    application: Application,

    listen: <args...>(event: Event<args...>, callback: (args...) -> ()) -> (),

    registerGlobalCommand: (commandData: Data) -> string?,
    deleteGlobalCommand: (ID: string) -> string?,
    registerGuildCommand: (guildID: string, data: Data) -> string?,

    replyInteraction: (interactionID: string, interactionToken: string, content: Data) -> string?,

    sendMessage: (channelID: string, content: string | Data, replyTo: string?) -> string?,
}

--[=[

    @class Session

    Main interface for interacting with Discord.

]=]

--// This
return Lumi.component('Session', function(self): Session
    --// Private
    local Token;
    local Shards = {}

    local API = Rest()
    local EventHandler = Listen()
    local State = State()
    local Mutex = Mutex()

    local Serializer = Serializer(self :: any, State)

    local function getApplicationData(): Application
        local botApp, err = API.getCurrentApplication()
        assert(botApp or not err, 'Could not get application data')

        return Serializer.data(botApp, Application)
    end

    --// Public

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
        @param token string -- Your application token

        Authenticates your token in Discord API. 
        Trying to call `Session.connect()` without a valid token 
        will throw an error.

    ]=]

    function self.login(token: string): ()
        assert(token ~= nil, 'No token has been sent.')
        Token = token

        local botUser, err = API.authenticate(Token)
        assert(botUser or not err, 'Authentication failed: ' .. (err and err.message or 'unknown'))

        self.user = Serializer.data(botUser, User)
        self.application = getApplicationData()
    end

    --[=[

        @within Session
        
        Connects to Discord Gateway, opening the websocket connection.  
        After calling it, your bot should go online and receive all Discord events.

        :::info Topologically-aware
        This function is only usable if called within the context of Session.login 
        :::

        @return (error: string?)

    ]=]

    function self.connect(): string?
        assert(Token ~= nil, 'No token available, authenticate first.')

        local Data, err = API.getGatewayBot()
        assert(not err or Data == nil, 'Could not authenticate: ' .. tostring(err and err.message))

        for shardID = 1, Data.shards do
            local shard = Shard(Token, EventHandler, Serializer, Mutex)
            Shards[shardID] = shard

            coroutine.wrap(shard.bind)(shardID - 1, Data.shards, Data.url, self.identify)
            task.wait(1)
        end

        return nil
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
        @param data Command -- A command object created by Lumi builders.

        Register a global application command in your BOT.

    ]=]

    function self.registerGlobalCommand(data: Data): string?
        local command, err = API.createGlobalApplicationCommand(self.application.ID, data)
        print(command, err)
        return err and err.message
    end

    --[=[

        @within Session
        @param guildID string -- The ID of the guild.
        @param data Command -- A command object created by Lumi builders.

        Register a guild-only application command in your BOT.

    ]=]

    function self.registerGuildCommand(guildID: string, data: Data): string?
        local _, err = API.createGuildApplicationCommand(self.application.ID, guildID, data)
        return err and err.message
    end

    --[=[

        @within Session
        @param ID string -- The ID of the command to be deleted.

        Delete a global application command in your BOT.

    ]=]

    function self.deleteGlobalCommand(ID: string): string?
        local _, err = API.deleteGlobalApplicationCommand(self.application.ID, ID)

        return err and err.message
    end

    --[=[

        @within Session
        @param interactionID string -- The ID of the interaction.
        @param token string -- The interaction token.
        @param data Data | string -- The response data or message.

        Send a response to an interaction.

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
        @param channelID string -- The ID of the channel.
        @param data string | {} -- The message content.
        @param replyTo string? -- The ID of the message to reply to.

        Sends a message in the given channel.  
        The content table needs to be created using builders available in Lumi.

        @return (error: string?) 

        :::info Topologically-aware
        This function is only usable if called within the context of Session.login 
        :::

    ]=]

    function self.sendMessage(channelID: string, data: string | Data, replyTo: string?): (string?)
        local payload = type(data) == 'table' and {content = data.content} or {content = data} :: any

        if replyTo then
            payload.message_reference = {message_id = replyTo}
        end

        local Data, error = API.createMessage(channelID, payload)

        if not Data and error then
            return nil, 'Could not send message: ' .. error.message
        end

        return error and error.message
    end

    return self
end)
