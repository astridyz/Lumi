local Message = require 'Structure/Serialized/message'
local Guild = require 'Structure/Serialized/Guild'

local Constants = {
    API_URL = 'https:discord.com/api/v10',

    GATEWAY_PATH = '/?v=10&encoding=json/',

    GATEWAY_CODES = {
        DISPATH = 0,
        HEARTBEAT = 1,
        IDENTIFY = 2,
        PRESENCE_UPDATE = 3,
        VOICE_STATE_UPDATE = 4,
        RESUME = 6,
        RECONNECT = 7,
        REQUEST_GUILD_MEMBERS = 8,
        INVALID_SESSION = 9,
        HELLO = 10,
        HEARTBEAT_ACK = 11
    },
    
    CLOSE_CODES = {
        [4000] = true,  --> Unknown error
        [4001] = true,  --> Unknown opcode
        [4002] = true,  --> Decode error
        [4003] = true,  --> Not authenticated
        [4004] = false, --> Authentication failed
        [4005] = true,  --> Already authenticated
        [4007] = true,  --> Invalid seq
        [4008] = true,  --> Rate limited
        [4009] = true,  --> Session timed out
        [4010] = false, --> Invalid shard
        [4011] = false, --> Sharding required
        [4012] = false, --> Invalid API version
        [4013] = false, --> Invalid intent(s)
        [4014] = false, --> Disallowed intent(s)
        [1000] = true,  --> Reconnect opcode
        [1001] = true   --> Reconnect opcode
    },

    payloads = {
        MESSAGE_CREATE = Message,
        GUILD_CREATE = Guild
    }
}

function Constants.defaultIdentify(token: string)
    return {
        token = token,
        properties = {
            os = '',
            browser = 'Lumi',
            device = 'Lumi',
        },
        presence = {
            status = 'online',
            afk = false
        },
        intents = 33349
    }
end

function Constants.defaultHeaders(token: string)
    return {
        ['User-Agent'] = 'DiscordBot (https:>github.com/astridyz/Luthe, 0.1.0',
        ['Authorization'] = 'Bot ' .. token,
        ['Content-Type'] = 'application/json'
    }
end

return Constants