--// Requires

local Class = require '../Class'
local Rest = require 'API/Rest'
local Listen = require 'Listen'
local Gateway = require 'API/Gateway'
local Constants = require '../Constants'

--// This

local Client = {}

function Client.wrap(): Client
    local self = Class()

    --// Private
    local TOKEN;

    local API = Rest.wrap()
    local Listener = Listen.wrap()
    local WebSocket;

    --// Public
    function self.login(token : Token)
        assert(token ~= nil, 'No token have been sent.')
        TOKEN = token

        return API.authenticate(TOKEN)
    end

    function self.connect(): Error?
        local Data, err = API:getGateway()
        if err then return err end

        WebSocket = Gateway.wrap(Data.url, Constants.GATEWAY_PATH)
        WebSocket.keep()
        WebSocket.handshake(TOKEN)
        WebSocket.initListeners(Listener)
        return
    end

    return self
end

export type Client = Class & {
    login : (Token : Token) -> ({[string] : any}?, Error?),
    connect : () -> Error?
}

type Error = Rest.Error
type Token = Rest.Token

type Class = Class.Class
type Listener = Listen.Listener

return Client