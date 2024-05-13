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

    --// Public
    function self.login(token : Token)
        assert(token ~= nil, 'No token have been sent.')
        TOKEN = token

        return API.authenticate(TOKEN)
    end

    function self.connect()
        local Data, _ = API.getGateway()
        Gateway.wrap(Data.url, Constants.GATEWAY_PATH, TOKEN)
    end

    return self
end

export type Client = Class & {
    login : (Token : Token) -> ({[string] : any}?, Error?),
    connect : () -> ()
}

type Error = Rest.Error
type Token = Rest.Token

type Class = Class.Class
type Gateway = Gateway.Gateway

return Client