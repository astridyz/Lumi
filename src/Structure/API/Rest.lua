--!strict
--// Packages
local Constants = require '../../Constants'

local Component = require '../../Component'
type Data = Component.Data

local net = require '@lune/net'
type httpMethod = net.HttpMethod

local Mutex = require '../Mutex'
type Mutex = Mutex.Mutex

--// Types
export type API = {
    authenticate: (Token: string) -> (Data, Data),

    getCurrentUser: () -> (Data, Error),
    getGatewayBot: () -> (Data?, Error),
    getGateway: () -> (Data?, Error),

    getCurrentApplication: () -> (Data, Error),

    getAllGlobalApplicationCommands: () -> (Data?, Error),
    getAllGuildApplicationCommands: (guildID: string) -> (Data?, Error),

    createGlobalApplicationCommand: (payload: Data) -> (Data?, Error),
    getGlobalApplicationCommand: (commandID: string) -> (Data?, Error),
    deleteGlobalApplicationCommand: (commandID: string) -> (Data?, Error),

    deleteGuildApplicationCommand: (guildID: string, ID: string) -> (Data?, Error),
    createGuildApplicationCommand: (guildID: string, payload: Data) -> (Data?, Error),

    createInteractionResponse: (interactionID: string, token: string, payload: Data) -> (Data?, Error),

    createMessage: (channelID: string, payload: Data) -> (Data?, Error),
}

export type Error = {
    message: string,
    code: number
}?

--// This
return Component.wrap('Rest', function(self): API
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

    local ApplicationID: number;

    local function sendRequest(...)
        local delay = Constants.defaultDelay
        local success, response = pcall(net.request, ...)

        if success and response.headers['x-ratelimit-remaining'] == '0' then
            local resetAfter = tonumber(response.headers['x-ratelimit-reset-after'])
            delay = resetAfter and math.max(resetAfter, delay) or delay
        end

        return success, response, delay
    end

    local function request(method: httpMethod, endpoint: string, payload: Data?): (Data?, Error)
        local url = Constants.apiUrl .. endpoint
        local Mutex = Mutexes[endpoint] :: Mutex

        Mutex.lock()
        local success, response, delay = sendRequest(
            {
            method = method,
            headers = Headers,
            url = url,
            body = payload and net.jsonEncode(payload) or nil
        })
        Mutex.unlockAfter(delay)
        
        local body = net.jsonDecode(response.body)

        if success and response.ok then
            return body
        end

        return nil, body
    end
    
    local function fetchData(endpoint: string)
        local data, err = request('GET', endpoint)
    
        if not data or err ~= nil then
            error('Could not get data from: ' .. endpoint .. 'Error: ' .. err.message)
        end
        
        return data :: Data
    end

    --// Public
    function self.authenticate(token: string)
        Headers = Constants.defaultHeaders(token)
        
        local user = self.getCurrentUser()
        local application = self.getCurrentApplication()

        ApplicationID = application.id

        return user, application
    end

    --// Gateway & User Requests
    function self.getCurrentUser()
        return fetchData('/users/@me')
    end

    function self.getGateway()
        return request('GET', '/gateway')
    end
    
    function self.getGatewayBot()
        return request('GET', '/gateway/bot')
    end

    --// Application Commands
    function self.getCurrentApplication()
        return fetchData('/applications/@me')
    end

    function self.getAllGlobalApplicationCommands()
        return request('GET', '/applications/' .. ApplicationID .. '/commands')
    end

    function self.createGlobalApplicationCommand(payload: Data)
        return request('POST', '/applications/' .. ApplicationID .. '/commands', payload)
    end

    function self.getGlobalApplicationCommand(commandID: string)
        return request('GET', '/applications/' .. ApplicationID .. '/commands/' .. commandID)
    end

    function self.deleteGlobalApplicationCommand(commandID: string)
        return request('DELETE', '/applications/' .. ApplicationID .. '/commands/' .. commandID)
    end

    function self.getAllGuildApplicationCommands(guildID: string)
        return request('GET', '/applications/' .. ApplicationID .. '/guilds/' .. guildID .. '/commands')
    end

    function self.createGuildApplicationCommand(guildID: string, payload: Data)
        return request('POST', '/applications/' .. ApplicationID .. '/guilds/' .. guildID .. '/commands', payload)
    end

    function self.deleteGuildApplicationCommand(guildID: string, ID: string)
        return request('DELETE', '/applications/' .. ApplicationID .. '/guilds/' .. guildID .. '/commands/' .. ID)
    end

    --// Interaction Responses
    function self.createInteractionResponse(interactionID: string, token: string, payload: Data)
        return request('POST', '/interactions/' .. ApplicationID .. '/' .. token .. '/callback', payload)
    end

    --// Message Related
    function self.createMessage(channelID: string, payload: Data)
        return request('POST', '/channels/' .. channelID .. '/messages', payload)
    end

    return self.query()
end)