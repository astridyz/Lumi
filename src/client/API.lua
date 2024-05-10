--// Requires

local Class = require('../class')
local net = require('@lune/net') :: any

--// Constants

local API_URL = 'https://discord.com/api/v10'
local USER_AGENT = string.format('DiscordBot (%s, %s)', 'https://github.com/astridyz/Luthe', '0.1.0')

--// This

local API = {}

function API.wrap(Client : Class): API
    local self = Class()

    --// Private
    local TOKEN;

    --// Public

    function self:authenticate(token : Token): ({}?, Error?)
        TOKEN = token
        return self:getCurrentUser()
    end

    function self:request(method : ApiRequest, endpoint : ApiRequest): ({}?, Error?)

        assert(TOKEN ~= nil, 'No bot token available')

        local url = API_URL .. endpoint

        local request = {
            ['User-Agent'] = USER_AGENT,
            ['Authorization'] = TOKEN,
            ['Content-Type'] = 'application/json'
        } :: Headers

        return self:commit(method, url, request)
    end

    function self:commit(method : ApiRequest, url : ApiRequest, headers : Headers ): ({}?, Error?)
        local success, response = pcall(function()
            return net.request {
                url = url,
                method = method,
                headers = headers
            }
        end)

        local data = response.ok and net.jsonDecode(response.body) or nil

		if success and data then
            print('Sucess ', data)
            return data, nil
        else
            print('RIP ', data)
            return nil, net.jsonDecode(response.body) :: Error
        end
    end

    --// Base requests

    function self:getCurrentUser()
        return self:request('GET', '/users/@me')
    end

    function self:getGateway()
        return self:request("GET", "/gateway")
    end
    
    function self:getGatewayBot()
        return self:request("GET", "/gateway")
    end

    return self
end

type ApiRequest = string
type Error = {
    message : string,
    code : number
}

export type Headers = {
    {[number] : string}
}

export type API = Class & {
    authenticate : (Token) -> ({}?, Error?),
    Request : (ApiRequest, ApiRequest) -> ({}?, Error?),
    Commit : (ApiRequest, ApiRequest, Headers) -> ({}?, Error?)
}

export type Token = string

type Class = Class.Class

return API