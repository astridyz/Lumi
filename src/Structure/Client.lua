--!strict
--// Requires

local Component = require '../Component'
local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Constants = require '../Constants'
local Events = require '../Events'
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

    function self.listen<output>(event : {payload: output, name: string, index: string}, callback: (...output) -> ())
        assert(Events[event.index], 'Invalid event type')
        Serializer.listen(event.name, callback)
    end

    function self.listenOnce<output>(event : {payload: output, name: string, index: string}, callback: (...output) -> ())
        assert(Events[event.index], 'Invalid event type')
        
        local listening; listening = Serializer.listen(event.name, function(...)
            callback(...)
            listening()
        end)
    end

    return self
end

export type Client = Instance & {
    login: (Token: string) -> ({[string]: any}?, Error?),
    connect: () -> (),
    listen: <output>(name: {payload: output, name: string, index: string}, callback: (...output) -> ()) -> (),
    listenOnce: <output>(name: {payload: output, name: string, index: string}, callback: (...output) -> ()) -> ()
}

type Error = Rest.Error

type Instance = Component.Instance
type Gateway = Gateway.Gateway

return Client