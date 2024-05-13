--!strict
--// Requires

local Class = require '../../Class'
local net = require '@lune/net'
local Constants = require '../../Constants'

--// This

local Request = {}

function Request.wrap(Token : Token, method, endpoint): (Data, Error?)
    local self = Class() :: Request

    --// Private
    local METHOD = method
    local ENDPOINT = endpoint
    local TOKEN = Token

    local URL;

    local HEADERS = {
        ['User-Agent'] = Constants.USER_AGENT,
        ['Authorization'] = 'Bot ' .. TOKEN,
        ['Content-Type'] = 'application/json'
    } :: Headers

    local function attempt()
        local success, response = pcall(function()
            return net.request {method = METHOD, headers = HEADERS, url = URL} :: FetchResponse
        end)

        local data = net.jsonDecode(response.body)

		if success and response.ok then
            return data, nil
        else
            return nil, net.jsonDecode(response.body)
        end
    end

    --// Public

    function self.request()
        assert(Token, 'Attempt to do a API request without bot token')
        URL = Constants.API_URL .. ENDPOINT
        
        return attempt()
    end

    return self.request()
end

export type RestRequest = string

export type Request = Class & {
    request : () -> (Data, Error?),
}

export type Token = string

export type Error = {
    message : string,
    code : number
}

export type Data = {[string] : any}

export type RequestResponse = {[string] : any}

type Class = Class.Class

type Headers = net.HttpHeaderMap
type HttpResponse = net.ServeResponse
type FetchResponse = net.FetchResponse

return Request