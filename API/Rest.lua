--!strict
--// Requires

local Class = require '../../Class'
local Request = require 'Request'

--// This

local Rest = {}

function Rest.wrap(): API
    local self = Class() :: API

    --// Private
    local TOKEN;

    --// Public

    function self.authenticate(token : Token)
        TOKEN = token
        return self.getCurrentUser()
    end

    --// Base requests

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

export type API = Class & {
    authenticate : (Token : string) -> (Data, Error?),
    --// Base methods
    getCurrentUser : () -> (Data, Error?),
    getGatewayBot : () -> (Data, Error?),
    getGateway : () -> (Data, Error?)
}

export type Token = Request.Token
export type Error = Request.Error
export type Data = Request.Data

type Class = Class.Class

return Rest