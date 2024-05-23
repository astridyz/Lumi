--!strict
--// Requires
local Lumi = require '../../Lumi'
local net = require '@lune/net'
local Constants = require '../../Constants'

local Mutex = require '../Mutex'

--// Types
type httpMethod = net.HttpMethod
type Data = Lumi.Data

type Mutex = Mutex.Mutex

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

--// This
return Lumi.component('Rest', function(self): API
    --// Mutex ratelimiting
    local meta = {}
    meta.__mode = 'v'
    
    function meta:__index(k)
        self[k] = Mutex()
        return self[k]
    end

    --// Private
    local Headers
    local Mutexes = setmetatable({}, meta)

    local function attempt(method: httpMethod, url: string, payload: Data?): (boolean, Data, number)
        local delay = Constants.defaultDelay
        
        local success, response = pcall(function()
            return net.request {
                method = method,
                headers = Headers,
                url = url,
                body = payload and net.jsonEncode(payload) or nil
            }
        end)
    
        if success and response.headers['x-ratelimit-remaining'] == '0' then
            local resetAfter = tonumber(response.headers['x-ratelimit-reset-after'])
            delay = resetAfter and math.max(resetAfter, delay) or delay
        end
    
        return success, response, delay
    end
    
    local function request(method: httpMethod, endpoint: string, payload: Data?): (Data?, Error)
        local URL = Constants.apiUrl .. endpoint
        local mutex = Mutexes[endpoint] :: Mutex
        
        mutex.lock()
        local success, response, delay = attempt(method, URL, payload)
        mutex.unlockAfter(delay)
    
        if success and response.ok then
            return net.jsonDecode(response.body), nil
        else
            return nil, net.jsonDecode(response.body)
        end
    end
    

    --// Public
    function self.authenticate(token: string)
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