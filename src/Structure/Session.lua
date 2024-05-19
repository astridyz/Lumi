--!strict
--// Requires
local Lumi = require '../Lumi'

local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Listen = require 'Listen'
local Cache = require 'Cache'
local Serializer = require 'Serializer'

local Constants = require '../Constants'
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
    login: (token: string) -> (Data?, Error?),
    connect: () -> (),
    listen: <args...>(event: Event<args...>, callback: (args...) -> ()) -> (),
    getGuild: (ID: string) -> Guild?,
    getUser: (ID: string) -> User?,
    sendMessage: (channelID: string, content: {[string]: any} | string) -> (boolean, string?),
}

--[=[

    @class Session

    Main interface for interacting with Discord.

    :::info Topologically-aware
        All functions bellow need an valid token and a opened gateway to be used.  
    :::

]=]

--// This
return Lumi.component('Session', function(self): Session
    --// Private
    local Token;

    local API = Rest()
    local Listener = Listen()

    local Guilds = Cache('Guild', 'k', Guild)
    local Users = Cache('User', 'k', User)
    local Channel = Cache('Channel', 'k', Channel)

    local Serializer = Serializer(self :: any, {Guilds, Users, Channel})

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

        local _, err = API.authenticate(Token)
        assert(not err, 'Authentication failed: ' .. (err and err.message or 'unknown'))
    end

    --[=[

        @within Session
        
        Connects in Discord Gateway, opening the websocket connection.  
        After calling it, your bot should go online and receive all Discord events.

    ]=]

    function self.connect()
        assert(Token ~= nil, 'No token available, authenticate first.')
        local Data, _ = API.getGateway()
        if Data then
            Gateway(Token, Listener, Serializer).socket(Data.url, Constants.gatewayPath)
            task.wait(1)
        end
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
        return Listener.listen(event.name, callback)
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
        @return (success: boolean, error: string?) 

        Sends a message in the given channel.  
        The content  table needs to be created using constructors available in Lumi.

    ]=]
    

    function self.sendMessage(channelID: string, content: {[string]: any} | string): (boolean, string?)
        assert(Token == nil, 'No token available, authenticate first.')

        if type(content) == 'table' then
            local result, err = API.createMessage(channelID, content)
            return result and true or false, err and err.message
        end

        if type(content) == 'string' then
            local result, err = API.createMessage(channelID, {content = content})
            return result and true or false, err and err.message
        end

        return false, 'Invalid message content body'
    end

    return self
end)