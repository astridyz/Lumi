--!strict
--// Requires
local Lumi = require '../Lumi'

local Rest = require 'API/Rest'
local Shard = require 'API/Shard'
local Listen = require 'Listen'
local Cache = require 'Cache'
local Serializer = require 'Serializer'

local Events = require '../Events'

local task = require '@lune/task'

local Guild = require 'Serialized/Guild'
local User = require 'Serialized/User'
local Channel = require 'Serialized/Channel'

--// Types
type Error = Rest.Error

type Guild = Guild.Guild
type User = User.User

type Data = Lumi.Data
type Event<args...> = Events.Event<args...>

export type Session = {
    login: (token: string) -> (),
    connect: () -> string?,
    listen: <args...>(event: Event<args...>, callback: (args...) -> ()) -> (),
    getGuild: (ID: string) -> Guild?,
    getUser: (ID: string) -> User?,
    sendMessage: (channelID: string, content: {[string]: any} | string) -> (string?),
    user: User
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

    local Guilds = Cache('Guild', 'k', Guild)
    local Users = Cache('User', 'k', User)
    local Channel = Cache('Channel', 'k', Channel)

    local Serializer = Serializer(self :: any, {Guilds, Users, Channel})

    --[=[

    @within Session
    @prop user User

    The bot user object.

    ]=]
    self.user = {} :: User

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

        for shardID = 1, Data and Data.shards do
            local shard = Shard(Token, EventHandler, Serializer)
            Shards[shardID] = shard

            coroutine.wrap(shard.socket)(shardID - 1, Data and Data.shards, Data and Data.url)
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

    function self.listen<args...>(event : Event<args...>, callback: (args...) -> ())
        assert(Events[event.index], 'Invalid event type')
        return EventHandler.listen(event.name, callback)
    end

    --- @within Session
    function self.getGuild(ID: string): Guild?
        return Guilds.get(ID)
    end


    --- @within Session
    function self.getUser(ID: string): User?
        return Users.get(ID)
    end

    --[=[

        @within Session
        @param content {} | string
        @return (error: string?) 

        Sends a message in the given channel.  
        The content  table needs to be created using constructors available in Lumi.

        :::info Topologically-aware
        This function is only usable if called within the context of Session.login 
        :::

    ]=]
    

    function self.sendMessage(channelID: string, content: {[string]: any} | string): (string?)
        assert(Token == nil, 'No token available, authenticate first.')

        if type(content) == 'table' then
            local _, err = API.createMessage(channelID, content)
            return err and err.message or nil
        end

        if type(content) == 'string' then
            local _, err = API.createMessage(channelID, {content = content})
            return err and err.message or nil
        end

        return 'Invalid message content body'
    end

    return self
end)