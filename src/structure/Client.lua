--// Requires

local Class = require '../Class'
local Rest = require 'API/Rest'
local Gateway = require 'Gateway'

--// This

local Client = {}

function Client.wrap(): Client
    local self = Class()

    --// Private
    local API = Rest.wrap(self)
    local WebSocket;

    local TOKEN;

    --// Public
    function self:login(token : Token)
        assert(token ~= nil, 'No token have been sent.')

        TOKEN = token
        return API:authenticate(TOKEN)
    end

    function self:connect()
        local Data, err = API:getGateway()

        if err ~= nil then
            error('Error getting gateway: ' .. err.messag)
        end

        WebSocket = Gateway.wrap(Data.url, '/?v=10&encoding=json')
        WebSocket:keep()
    end

    return self
end

export type Client = Class & {
    login : (Token : Token) -> ({[string] : any}?, Error?)
}

type Error = Rest.Error
type Class = Class.Class
type Token = Rest.Token

return Client