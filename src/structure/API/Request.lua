--// Requires

local Class = require '../../Class'
local net = require '@lune/net' :: any

--// Constants

local API_URL = 'https://discord.com/api/v10'
local USER_AGENT = string.format('DiscordBot (%s, %s)', 'https://github.com/astridyz/Luthe', '0.1.0')

--// This

local Request = {}

function Request.wrap(Token : Token): Request
    local self = Class()

    --// Private
    local METHOD;
    local URL;
    local TOKEN = Token

    local HEADERS = {
        ['User-Agent'] = USER_AGENT,
        ['Authorization'] = 'Bot ' .. TOKEN,
        ['Content-Type'] = 'application/json'
    } :: Headers

    local function attempt()
        local success, response = pcall(function()
            return net.request { url = URL, method = METHOD, headers = HEADERS } :: httpResponse
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

        URL = API_URL .. endpoint
        METHOD = method

        return attempt()
    end

    return self
end

export type RestRequest = string

export type Request = Class & {
    request : (method : RestRequest, endpoint : RestRequest) -> ({}?, Error?),
}

export type Headers = {
    {[number] : string}
}

export type Token = string

export type Error = {
    message : string,
    code : number
}

export type httpResponse = {
    ['ok'] : boolean,
    ['body'] : string
}

export type RequestResponse = {[string] : any}

type Class = Class.Class

return Request