--!strict
--// Requires
local Lumi = require '../Lumi'

local Rest = require 'API/Rest'
local Gateway = require 'API/Gateway'
local Listen = require 'Listen'
local Cache = require 'Cache'
local Serializer = require 'Serializer'

local Constants = require '../Constants'
local Events = require '../Events'

local task = require '@lune/task'

local Guild = require 'Serialized/Guild'
local User = require 'Serialized/User'

--// Types
type Error = Rest.Error

type Guild = Guild.Guild
type User = User.User

type Data = Lumi.Data

export type Client = {
    login: (Token: string) -> (Data?, Error?),
    connect: () -> (),
    listen: <args...>(name: {payload: (args...) -> ()} & any, callback: (args...) -> ()) -> (),
    listenOnce: <args...>(name: {payload: (args...) -> ()} & any, callback: (args...) -> ()) -> (),
    getGuild: (ID: string) -> Guild?,
    getUser: (ID: string) -> User?,
    sendMessage: (channelID: string, content: {[string]: any} | string) -> (boolean, string?),
}

--// This
return Lumi.component('Client', function(self): Client
    --// Private
    local Token;

    local API = Rest()
    local Listener = Listen()

    local Guilds = Cache('Guild', 'k', Guild)
    local Users = Cache('User', 'k', User)

    local Serializer = Serializer(self :: any, {Guilds, Users})

    --// Methods
    function self.login(token: string)
        assert(token ~= nil, 'No Token have been sent.')
        Token = token

        local result, err = API.authenticate(Token)
        assert(not err, 'Authentication failed: ' .. (err and err.message or 'unknown'))

        return result
    end

    function self.connect()
        local Data, _ = API.getGateway()
        if Data then
            Gateway(Token, Listener, Serializer).socket(Data.url, Constants.gatewayPath)
            task.wait(1)
        end
    end

    function self.listen<args...>(event : {payload: (args...) -> ()} & any, callback: (args...) -> ())
        assert(Events[event.index], 'Invalid event type')
        Listener.listen(event.name, callback)
    end

    function self.listenOnce<args...>(event : {payload: (args...) -> ()} & any, callback: (args...) -> ())
        assert(Events[event.index], 'Invalid event type')
        
        local listening; listening = Listener.listen(event.name, function(...)
            callback(...)
            listening()
        end)
    end

    function self.getGuild(ID: string): Guild?
        return Guilds.get(ID)
    end

    function self.getUser(ID: string): User?
        return Users.get(ID)
    end

    function self.sendMessage(channelID: string, content: {[string]: any} | string): (boolean, string?)
        if type(content) == 'table' then
            local _, err = API.createMessage(channelID, content)
            return true, err and err.message
        end

        if type(content) == 'string' then
            local _, err = API.createMessage(channelID, {content = content})
            return true, err and err.message
        end

        return false, 'Invalid message content body'
    end

    return self
end)