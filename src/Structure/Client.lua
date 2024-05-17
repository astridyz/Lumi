--!strict
--// Requires

local Component = require '../Component'
local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Constants = require '../Constants'
local Events = require '../Events'
local Listen = require 'Listen'
local Cache = require 'Cache'
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

    local Serializer = Serializer.wrap(
        Cache.wrap('Guild', 'k', Guild),
        Cache.wrap('User', 'k', User)
    )

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
            Gateway.wrap(TOKEN, Listener, Serializer).socket(Data.url, Constants.GATEWAY_PATH)
            task.wait(1) --// Waiting for ready and important events after it
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

    function self.getGuild(ID: string): Guild
        return Serializer.syncs.get('Guild').get(ID)
    end

    function self.getUser(ID: string): User
        return Serializer.syncs.get('User').get(ID)
    end

    return self
end

export type Client = Instance & {
    login: (Token: string) -> ({[string]: any}?, Error?),
    connect: () -> (),
    listen: <args...>(name: {payload: (args...) -> ()} & any, callback: (args...) -> ()) -> (),
    listenOnce: <args...>(name: {payload: (args...) -> ()} & any, callback: (args...) -> ()) -> (),
    getGuild: (ID: string) -> Guild,
    getUser: (ID: string) -> User
}

type Instance = Component.Instance

type Gateway = Gateway.Gateway
type Error = Rest.Error

type Guild = Guild.Guild
type User = User.User

return Client