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

    local function send(method : ApiRequest, url : ApiRequest, headers : Headers): ({}?, Error?)
        local success, response = pcall(function()
            return net.request {url = url, method = method, headers = headers } :: httpResponse
        end)

        local data = net.jsonDecode(response.body) :: RequestResponse
        print(data)

		if success and response.ok then
            return data, nil
        else
            return nil, net.jsonDecode(response.body) :: Error
        end
    end

    local function request(method : ApiRequest, endpoint : ApiRequest): ({}?, Error?)
        assert(TOKEN ~= nil, 'No bot token available')

        local url = API_URL .. endpoint

        local request = {
            ['User-Agent'] = USER_AGENT,
            ['Authorization'] = TOKEN,
            ['Content-Type'] = 'application/json'
        } :: Headers

        return send(method, url, request)
    end

    --// Public

    function self:authenticate(token : Token): ({}?, Error?)
        TOKEN = token
        return self:getCurrentUser()
    end

    --// Base requests

    function self:getCurrentUser()
        return request('GET', '/users/@me')
    end

    function self:getGateway()
        return request("GET", "/gateway")
    end
    
    function self:getGatewayBot()
        return request("GET", "/gateway")
    end

    return self :: API
end

export type ApiRequest = string

export type Error = {
    message : string,
    code : number
}

export type httpResponse = {
    ['ok'] : boolean,
    ['body'] : string
}

export type RequestResponse = {[string] : any}

export type Headers = {
    {[number] : string}
}

export type API = Class & {
    authenticate : (Token : string) -> ({}?, Error?),
    --// Base methods
    getCurrentUser : () -> ({}?, Error?),
    getGatewayBot : () -> ({}?, Error?),
    getGateway : () -> ({}?, Error?)
}

export type Token = string

type Class = Class.Class

return API