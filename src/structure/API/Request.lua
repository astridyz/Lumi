--// Requires

local Class = require '../../Class'
local net = require '@lune/net'
local Constants = require '../../Constants'

--// This

local Request = {}

function Request.wrap(Token : Token): Request
    local self = Class()

    --// Private
    local METHOD;
    local URL;
    local TOKEN = Token

    local HEADERS = {
        ['User-Agent'] = Constants.USER_AGENT,
        ['Authorization'] = 'Bot ' .. TOKEN,
        ['Content-Type'] = 'application/json'
    } :: Headers

    local function attempt()
        local success, response = pcall(function()
            return net.request {method = METHOD, headers = HEADERS, url = URL} :: FetchResponse
        end)

        local data = net.jsonDecode(response.body) :: RequestResponse

		if success and response.ok then
            return data, nil
        else
            return nil, net.jsonDecode(response.body) :: Error
        end
    end

    --// Public

    function self:request(method : RestRequest, endpoint : RestRequest)
        assert(TOKEN ~= nil, 'No bot token available')

        URL = Constants.API_URL .. endpoint
        METHOD = method

        return attempt()
    end

    return self
end

export type RestRequest = string

export type Request = Class & {
    request : (method : RestRequest, endpoint : RestRequest) -> ({}?, Error?),
}

export type Token = string

export type Error = {
    message : string,
    code : number
}

export type RequestResponse = {[string] : any}

type Class = Class.Class

type Headers = net.HttpHeaderMap
type HttpResponse = net.ServeResponse
type FetchResponse = net.FetchResponse

return Request