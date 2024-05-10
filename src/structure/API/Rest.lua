--// Requires

local Class = require '../../Class'
local Request = require 'Request'

--// This

local Rest = {}

function Rest.wrap(Client : Class): API
    local self = Class()

    --// Private
    local TOKEN;

    --// Public

    function self:authenticate(token : Token): ({}?, Error?)
        TOKEN = token
        return self:getCurrentUser()
    end

    --// Base requests

    function self:getCurrentUser()
        local result = Request.wrap(TOKEN)
        return result:request('GET', '/users/@me')
    end

    function self:getGateway()
        local result = Request.wrap(TOKEN)
        return result:request('GET', '/gateway')
    end
    
    function self:getGatewayBot()
        local result = Request.wrap(TOKEN)
        return result:request('GET', '/gateway/bot')
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

export type RequestResponse = Request.RequestResponse
export type Token = Request.Token
export type Error = Request.Error

type Class = Class.Class
type httpResponse = Request.httpResponse

return Rest