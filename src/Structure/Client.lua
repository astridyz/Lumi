--!strict
--// Requires

local Component = require '../Component'

local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Listen = require 'Listen'
local Cache = require 'Cache'

local Constants = require '../Constants'
local Events = require '../Events'

local task = require '@lune/task'

local Serializer = require 'Serializer'

local Guild = require 'Serialized/Guild'
local User = require 'Serialized/User'

--// This

local Client = {}

function Client.wrap(): Client
    local self = Component() :: Client

    --// Private
    local TOKEN;

    local API = Rest.wrap()
    local Listener = Listen.wrap()

    local Guilds = Cache.wrap('Guild', 'k', Guild)
    local Users = Cache.wrap('User', 'k', User)

    local Serializer = Serializer.wrap(self, Guilds, Users)

    --// Public
    function self.login(token: string)
        assert(token ~= nil, 'No token have been sent.')
        TOKEN = token

        local result, err = API.authenticate(TOKEN)
        assert(not err, 'Authentication failed: ' .. (err and err.message or 'unknown'))

        return result
    end

    function self.connect()
        local Data, _ = API.getGateway()
        if Data then
            Gateway.wrap(TOKEN, Listener, Serializer).socket(Data.url, Constants.gatewayPath)
            task.wait(1)
        end
    end

    function self.listen<args...>(event : {payload: (args...) -> ()} & any, callback: (args...) -> ())
        assert(Events[event.index], 'Invalid event type')
        Listener.listen(event.name, callback)
    end

    function self.listenOnce<args...>(event : {payload: (args...) -> ()} & any, callback: (args...) -> ())
        assert(Events[event.index], 'Invalid event type')
        
        local listening; listening = Listener.listen(event.name, function(...)
            callback(...)
            listening()
        end)
    end

    function self.getGuild(ID: string): (Guild?, string?)
        return Guilds.get(ID)
    end

    function self.getUser(ID: string): User
        return Users.get(ID)
    end

    function self.sendMessage(channelID: string, content: {[string]: any} | string): (true?, string?)
        if type(content) == 'table' then
            local _, err = API.createMessage(channelID, content)
            return true, err and err.message
        end

        if type(content) == 'string' then
            local _, err = API.createMessage(channelID, {content = content})
            return true, err and err.message
        end

        return nil, 'Invalid message content body'
    end

    return self
end

export type Client = Instance & {
    login: (Token: string) -> (Data?, Error?),
    connect: () -> (),
    listen: <args...>(name: {payload: (args...) -> ()} & any, callback: (args...) -> ()) -> (),
    listenOnce: <args...>(name: {payload: (args...) -> ()} & any, callback: (args...) -> ()) -> (),
    getGuild: (ID: string) -> (Guild?, string?),
    getUser: (ID: string) -> User,
    sendMessage: (channelID: string, content: {[string]: any} | string) -> (true?, string?),
}

type Instance = Component.Instance

type Gateway = Gateway.Gateway
type Error = Rest.Error

type Data = Rest.Data

type Guild = Guild.Guild
type User = User.User

return Client