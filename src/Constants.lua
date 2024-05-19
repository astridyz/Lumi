local Message = require 'Structure/Serialized/message'
local Guild = require 'Structure/Serialized/Guild'
local Member = require 'Structure/Serialized/Member'
local Channel = require 'Structure/Serialized/Channel'
-- local User = require 'Structure/Serialized/User'

local Constants = {
    apiUrl = 'https:discord.com/api/v10',

    gatewayPath = '/?v=10&encoding=json/',

    gatewayCodes = {
        dispatch = 0,
        heartbeat = 1,
        identify = 2,
        presenceUpdate = 3,
        voiceStateUpdate = 4,
        resume = 6,
        reconnect = 7,
        requestGuildMembers = 8,
        invalidSession = 9,
        hello = 10,
        heartbeatAck = 11
    },
    
    CLOSE_CODES = {
        [4000] = true,  --// Unknown error
        [4001] = true,  --// Unknown opcode
        [4002] = true,  --// Decode error
        [4003] = true,  --// Not authenticated
        [4004] = false, --// Authentication failed
        [4005] = true,  --// Already authenticated
        [4007] = true,  --// Invalid seq
        [4008] = true,  --// Rate limited
        [4009] = true,  --// Session timed out
        [4010] = false, --// Invalid shard
        [4011] = false, --// Sharding required
        [4012] = false, --// Invalid API version
        [4013] = false, --// Invalid intent(s)
        [4014] = false, --// Disallowed intent(s)
        [1000] = true,  --// Reconnect opcode
        [1001] = true   --// Reconnect opcode
    },

    payloads = {
        MESSAGE_CREATE = Message,
        MESSAGE_UPDATE = Message,
        GUILD_CREATE = Guild,
        GUILD_UPDATE = Guild,
        GUILD_MEMBER_ADD = Member,
        GUILD_MEMBER_REMOVE = Member,
        CHANNEL_CREATE = Channel,
        CHANNEL_UPDATE = Channel,
        CHANNEL_DELETE = Channel,
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
        ['User-Agent'] = 'DiscordBot (https://github.com/astridyz/Luthe, 0.1.0)',
        ['Authorization'] = 'Bot ' .. token,
        ['Content-Type'] = 'application/json'
    }
end

return Constants