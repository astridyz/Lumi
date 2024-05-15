--!strict
--> Requires

local Component = require '../Component'
local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Constants = require '../Constants'
local Serializer = require 'Serializer'

--> This

local Client = {}

function Client.wrap(): Client
    local self = Component() :: Client

    --> Private
    local TOKEN;

    local API = Rest.wrap()
    local Serializer = Serializer.wrap()

    --> Public
    function self.login(token: string)
        assert(token ~= nil, 'No token have been sent.')
        TOKEN = token

        local result, err = API.authenticate(TOKEN)
        assert(not err, 'Authentication failed: ' .. (err and err.message or 'unknown'))

        return result
    end

    function self.connect()
        local Data, _ = API.getGateway()
        Gateway.wrap(Data.url, Constants.GATEWAY_PATH, TOKEN, Serializer)
    end

    function self.event<args...>(name : string, callback: (args...) -> ())
        assert(Constants.CLIENT_EVENTS[name], 'Event name not found')
        Serializer.listen(name, callback)
    end

    return self
end

export type Client = Instance & {
    login: (Token: string) -> ({[string]: any}?, Error?),
    connect: () -> (),
    event: <args...>(name : string, callback: (args...) -> ()) -> ()
}

type Error = Rest.Error

type Instance = Component.Instance
type Gateway = Gateway.Gateway

return Client