--!strict
--// Requires
local Component = require '../../Component'
local net = require '@lune/net'
local Constants = require '../../Constants'

--// This
local Rest = {}

function Rest.wrap(): API
    local self = Component() :: API

    --// Private
    local TOKEN;

    local function request(token: string, method: httpMethod, endpoint: string): (Data, Error)
        assert(token, 'Attempt to do an API request without a valid bot token')
    
        local URL = Constants.API_URL .. endpoint
        local HEADERS = Constants.defaultHeaders(token)

        local success, response = pcall(function()
            return net.request {
                method = method,
                headers = HEADERS,
                url = URL}
        end)
    
        local package = net.jsonDecode(response.body)
    
        if success and response.ok then
            return package, nil
        else
            return nil, net.jsonDecode(response.body)
        end
    end

    --// Public
    function self.authenticate(token: string)
        TOKEN = token
        return self.getCurrentUser()
    end

    --// Base requests
    function self.getCurrentUser()
        return request(TOKEN, 'GET', '/users/@me')
    end

    function self.getGateway()
        return request(TOKEN, 'GET', '/gateway')
    end
    
    function self.getGatewayBot()
        return request(TOKEN, 'GET', '/gateway/bot')
    end

    return self
end

export type API = Instance & {
    authenticate: (Token: string) -> (Data, Error),
    getCurrentUser: () -> (Data, Error),
    getGatewayBot: () -> (Data, Error),
    getGateway: () -> (Data, Error)
}

export type Error = {
    message: string,
    code: number
}?

export type Data = {[string] : any}?

type Instance = Component.Instance

type httpMethod = net.HttpMethod

return Rest