--// Requires

local Class = require '../../Class'
local Request = require 'Request'

--// This

local Rest = {}

function Rest.wrap(): API
    local self = Class()

    --// Private
    local TOKEN;

    --// Public

    function self.authenticate(token : Token): ({}?, Error?)
        TOKEN = token
        return self:getCurrentUser()
    end

    --// Base requests

    function self:getCurrentUser()
        return Request.wrap(TOKEN, 'GET', '/users/@me')
    end

    function self:getGateway()
        return Request.wrap(TOKEN, 'GET', '/gateway')
    end
    
    function self:getGatewayBot()
        return Request.wrap(TOKEN, 'GET', '/gateway/bot')
    end

    return self :: API
end

export type API = Class & {
    authenticate : (Token : string) -> ({}?, Error?),
    --// Base methods
    getCurrentUser : () -> ({}?, Error?),
    getGatewayBot : () -> ({}?, Error?),
    getGateway : () -> ({}?, Error?)
}

export type Token = Request.Token
export type Error = Request.Error

type Class = Class.Class

return Rest