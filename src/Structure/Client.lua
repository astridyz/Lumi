--!strict
--> Requires

local Component = require '../Component'
local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Constants = require '../Constants'

--> This

local Client = {}

function Client.wrap(): Client
    local self = Component() :: Client

    --> Private
    local TOKEN;

    local API = Rest.wrap()

    --> Public
    function self.login(token: string)
        assert(token ~= nil, 'No token have been sent.')
        TOKEN = token

        local result, err = API.authenticate(TOKEN)
        if err then
            error(err.message .. '. Invalid token.')
        end

        return result
    end

    function self.connect()
        local Data, _ = API.getGateway()
        Gateway.wrap(Data.url, Constants.GATEWAY_PATH, TOKEN)
    end

    return self
end

export type Client = Instance & {
    login: (Token: string) -> ({[string]: any}?, Error?),
    connect: () -> ()
}

type Error = Rest.Error

type Instance = Component.Instance
type Gateway = Gateway.Gateway

return Client