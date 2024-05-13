--!strict
--// Requires

local Class = require '../../Class'
local net = require '@lune/net'
local Constants = require '../../Constants'

--// This

local Request = {}

function Request.wrap(token : Token, method : httpMethod, endpoint : urlEnpoint): (Data, Error?)
    local self = Class() :: Request

    --// Private
    local URL;
    local HEADERS = Constants.defaultHeaders(token)

    local function attempt()
        local success, response = pcall(function()
            return net.request {method = method, headers = HEADERS, url = URL} :: FetchResponse
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
        assert(token, 'Attempt to do a API request without bot token')
        URL = Constants.API_URL .. endpoint
        
        return attempt()
    end

    return self.request()
end

export type httpMethod = net.HttpMethod
export type urlEnpoint = string

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