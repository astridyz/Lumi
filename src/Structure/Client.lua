--!strict
--// Requires

local Component = require '../Component'
local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Constants = require '../Constants'
local Serializer = require 'Serializer'

--// This

local Client = {}

function Client.wrap(): Client
    local self = Component() :: Client

    --// Private
    local TOKEN;

    local API = Rest.wrap()
    local Serializer = Serializer.wrap()

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
            Gateway.wrap(Data.url, Constants.GATEWAY_PATH, TOKEN, Serializer)
        end
    end

    function self.listen(name : string, callback: (...any) -> ())
        assert(Constants.CLIENT_EVENTS[name], 'Event name not found')
        Serializer.listen(name, callback)
    end

    function self.listenOnce(name : string, callback: (...any) -> ())
        assert(Constants.CLIENT_EVENTS[name], 'Event name not found')

        local listening; listening = Serializer.listen(name, function(...)
            callback(...)
            listening()
        end)
    end

    return self
end

export type Client = Instance & {
    login: (Token: string) -> ({[string]: any}?, Error?),
    connect: () -> (),
    listen: (name : string, callback: (...any) -> ()) -> (),
    listenOnce: (name : string, callback: (...any) -> ()) -> ()
}

type Error = Rest.Error

type Instance = Component.Instance
type Gateway = Gateway.Gateway

return Client