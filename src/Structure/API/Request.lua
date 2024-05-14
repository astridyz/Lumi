--!strict
--> Requires
local Component = require '../../Component'
local net = require '@lune/net'
local Constants = require '../../Constants'

--> This
local Request = {}

function Request.wrap(token: string, method: httpMethod, endpoint: urlEnpoint)
    assert(token, 'Attempt to do an API request without a valid bot token')
    local self = Component() :: Request

    --> Private
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

    --> Public
    function self.request()
        URL = Constants.API_URL .. endpoint
        
        return attempt()
    end

    return self.request()
end

export type urlEnpoint = string

export type Request = Instance & {
    request: () -> (Data, Error?),
}

export type Error = {
    message: string,
    code: number
}

export type Data = {[string]: any}

export type RequestResponse = {[string]: any}

type Instance = Component.Instance

type Headers = net.HttpHeaderMap
type HttpResponse = net.ServeResponse
type FetchResponse = net.FetchResponse
type httpMethod = net.HttpMethod

return Request