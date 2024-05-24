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

--// Types
type Error = Rest.Error

type Data = Lumi.Data
type Event<args...> = Events.Event<args...>

type State = State.State
type User = User.User
type Message = Message.Message

type Identify = Shard.Identify

export type Session = {
    login: (token: string) -> (),
    identify: Identify,
    connect: () -> string?,
    state: State,
    user: User,
    listen: <args...>(event: Event<args...>, callback: (args...) -> ()) -> (),
    sendMessage: (channelID: string, content: string | {[string]: any}, replyTo: string?) -> (string?),
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

    --// Public

    --[=[

        @within Session
        @prop state State

        The currently state for all data in session.

    ]=]

    self.state = State

    --[=[
    
        @within Session
        @prop identify Identify

        Some information useful for handshake with Discord.
        Check docs for more information about this

    ]=]

    self.identify = {} :: Identify

    --// Methods

    --[=[

        @within Session
        @param token string -- Your application token

        Authenticates your token in Discord API, 
        trying to call `Session.connect()` without a valid token 
        will throw an error.

    ]=]

    function self.login(token: string)
        assert(token ~= nil, 'No Token have been sent.')
        Token = token

        local botUser, err = API.authenticate(Token)
        assert(not err, 'Authentication failed: ' .. (err and err.message or 'unknown'))

        if botUser then
            self.user = Serializer.data(botUser, User)
        end
    end

    --[=[

        @within Session
        
        Connects in Discord Gateway, opening the websocket connection.  
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
        @param event {} -- A event object. All events are listed in `Events.lua` file.

        Listen to a given `Event` and calls a callback when it is emitted.
        
        ### Usage Example:

        ```lua
        Session.listen(Events.messageCreate, function(message)
            print(message.author.ID)
        end)
        ```

    ]=]

    function self.listen<args...>(event: Event<args...>, callback: (args...) -> ())
        assert(Events[event.index], 'Invalid event type')
        return EventHandler.listen(event.name, callback)
    end

    --[=[

        @within Session
        @param content {} | string
        @return (message: Message?, error: string?) 

        Sends a message in the given channel.  
        The content  table needs to be created using constructors available in Lumi.

        :::info Topologically-aware
        This function is only usable if called within the context of Session.login 
        :::

    ]=]
    

    function self.sendMessage(channelID: string, content: string | Data, replyTo: string?): (string?)
        local payload = type(content) == 'table' and content or {content = content} :: Data

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