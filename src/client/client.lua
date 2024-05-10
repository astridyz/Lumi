--// Requires

local Class = require('../class')
local APIClass = require('API')

local task = require("@lune/task") :: any

--// This

local Client = {}

function Client.wrap(): Client
    local self = Class()

    --// Private
    local API = APIClass.wrap(self)
    local TOKEN;

    local function login(self, token)
        assert(token ~= nil, 'No token have been sent.')
        
        --// Formated token
        TOKEN = 'Bot ' .. token

        local User, err = API:authenticate(TOKEN)
        if err then
            error('Could not authenticate, error: ' .. err.message)
        end

        API:getGatewayBot()

        return User
    end

    --// Public
    function self:login(token : Token)
        local result = task.spawn(login, self, token)
        return result
    end

    return self
end

export type Client = Class & {
    login : (Token) -> ()
}

type Class = Class.Class
type Token = APIClass.Token

return Client