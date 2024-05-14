--!strict
--> Requires
local Component = require '../../Component'
local Request = require 'Request'

--> This
local Rest = {}

function Rest.wrap(): API
    local self = Component() :: API

    --> Private
    local TOKEN;

    --> Public
    function self.authenticate(token: string)
        TOKEN = token
        return self.getCurrentUser()
    end

    --> Base requests
    function self.getCurrentUser()
        return Request.wrap(TOKEN, 'GET', '/users/@me')
    end

    function self.getGateway()
        return Request.wrap(TOKEN, 'GET', '/gateway')
    end
    
    function self.getGatewayBot()
        return Request.wrap(TOKEN, 'GET', '/gateway/bot')
    end

    return self
end

export type API = Instance & {
    authenticate: (Token: string) -> (Data, Error?),
    --> Base methods
    getCurrentUser: () -> (Data, Error?),
    getGatewayBot: () -> (Data, Error?),
    getGateway: () -> (Data, Error?)
}

export type Error = Request.Error
export type Data = Request.Data

type Instance = Component.Instance

return Rest