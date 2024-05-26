--!strict
--// Requires
local Lumi = require '../../Lumi'
local Constants = require '../../Constants'

local net = require '@lune/net'

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

    getCurrentApplication: () -> (Data, Error),

    createGlobalApplicationCommand: (ID: string, payload: Data) -> (Data, Error),
    getGlobalApplicationCommand: (ID: string, commandID: string) -> (Data, Error),
    deleteGlobalApplicationCommand: (ID: string, commandID: string) -> (Data, Error),
    createGuildApplicationCommand: (ID: string, guildID: string, payload: Data) -> (Data, Error),

    createInteractionResponse: (ID: string, token: string, payload: Data) -> (Data, Error),

    createMessage: (channelID: string, payload: Data) -> (Data, Error),
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

        local function sendRequest(...)
            local delay = Constants.defaultDelay
            local success, response = pcall(net.request, ...)

            if success and response.headers['x-ratelimit-remaining'] == '0' then
                local resetAfter = tonumber(response.headers['x-ratelimit-reset-after'])
                delay = resetAfter and math.max(resetAfter, delay) or delay
            end

            return success, response, delay
        end

        local function request(method: httpMethod, endpoint: string, payload: Data?): any
            local url = Constants.apiUrl .. endpoint
            local mutex = Mutexes[endpoint] :: Mutex

            mutex.lock()
            local success, response, delay = sendRequest({
                method = method, headers = Headers, url = url, body = payload 
                and net.jsonEncode(payload) or nil
            })
            mutex.unlockAfter(delay)

            if response.body == '' or response.body == ' ' then
                return
            end
            
            local body = net.jsonDecode(response.body)

            if success and response.ok then
                return body
            else
                return nil, body
            end
        end
    

    --// Public
    function self.authenticate(token: string)
        Headers = Constants.defaultHeaders(token)

        return self.getCurrentUser()
    end

    --// Gateway & User Requests
    function self.getCurrentUser()
        return request('GET', '/users/@me')
    end

    function self.getGateway()
        return request('GET', '/gateway')
    end
    
    function self.getGatewayBot()
        return request('GET', '/gateway/bot')
    end

    --// Application Commands
    function self.getCurrentApplication()
        return request('GET', '/applications/@me')
    end

    function self.createGlobalApplicationCommand(ID: string, payload: Data)
        return request('POST', '/applications/' .. ID .. '/commands', payload)
    end

    function self.getGlobalApplicationCommand(ID: string, commandID: string)
        return request('GET', '/applications/' .. ID .. '/commands/' .. commandID)
    end

    function self.deleteGlobalApplicationCommand(ID: string, commandID: string)
        return request('DELETE', '/applications/' .. ID .. '/commands/' .. commandID)
    end

    function self.createGuildApplicationCommand(ID: string, guildID: string, payload: Data)
        return request('POST', '/applications/' .. ID .. '/guilds/' .. guildID .. '/commands', payload)
    end

    --// Interaction Responses
    function self.createInteractionResponse(ID: string, token: string, payload: Data)
        return request('POST', '/interactions/' .. ID .. '/' .. token .. '/callback', payload)
    end

    --// Message Related
    function self.createMessage(channelID: string, payload: Data)
        return request('POST', '/channels/' .. channelID .. '/messages', payload)
    end

    return self
end)