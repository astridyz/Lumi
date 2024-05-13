--!strict
--// Requires

local Class = require '../Class'
local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Constants = require '../Constants'

--// This

local Client = {}

function Client.wrap(): Client
    local self = Class() :: Client

    --// Private
    local TOKEN;

    local API = Rest.wrap()
    local WebSocket : Gateway;

    local function reconnect()
        WebSocket.close()
        self.connect()
    end

    local function tryResume(closeCode : number?): ()
        if Constants.closeCodes[closeCode] then
            WebSocket.resume()
            return
        end

        reconnect()
    end

    --// Public
    function self.login(token : Token)
        assert(token ~= nil, 'No token have been sent.')
        TOKEN = token

        return API.authenticate(TOKEN)
    end

    function self.connect(): Error?
        local Data, err = API.getGateway()
        if err or not Data then
            return err
        end

        WebSocket = Gateway.wrap(
            Data.url,
            Constants.GATEWAY_PATH,
            tryResume,
            TOKEN
        )
        WebSocket.open()
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
type Gateway = Gateway.Gateway

return Client