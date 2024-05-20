--!strict
--// Requires
local Lumi = require '../../Lumi'
local net = require '@lune/net'
local Constants = require '../../Constants'

--// Types
type httpMethod = net.HttpMethod

export type API = {
    authenticate: (Token: string) -> (Data, Error),
    getCurrentUser: () -> (Data, Error),
    getGatewayBot: () -> (Data, Error),
    getGateway: () -> (Data, Error),
    createMessage: (channelID: string, payload: Data) -> (Data, Error),
    getGuild: (guildID: string) -> (Data, Error)
}

export type Error = {
    message: string,
    code: number
}?

export type Data = {[string] : any}?

--// This
return Lumi.component('Rest', function(self): API
    --// Private
    local Token
    local Headers

    local function request(method: httpMethod, endpoint: string, payload: Data?): (Data?, Error)
        assert(Token, 'Attempt to do an API request without a valid bot token')
    
        local URL = Constants.apiUrl .. endpoint

        local success, response = pcall(function()
            return net.request {
                method = method,
                headers = Headers,
                url = URL,
                body = payload and net.jsonEncode(payload) or nil
            }
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
        Token = token
        Headers = Constants.defaultHeaders(token)

        return self.getCurrentUser()
    end

    --// Base requests
    function self.getCurrentUser()
        return request('GET', '/users/@me')
    end

    function self.getGateway()
        return request('GET', '/gateway')
    end
    
    function self.getGatewayBot()
        return request('GET', '/gateway/bot')
    end

    function self.createMessage(channelID: string, payload: Data)
        return request('POST', '/channels/' .. channelID .. '/messages', payload)
    end

    function self.getGuild(guildID: string)
        return request('GET', '/guilds/' .. guildID)
    end

    return self
end)