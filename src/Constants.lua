local Message = require 'Structure/Serialized/message'
local Guild = require 'Structure/Serialized/Guild'
local Member = require 'Structure/Serialized/Member'
local Channel = require 'Structure/Serialized/Channel'
local Role = require 'Structure/Serialized/Role'
local Specifics = require 'Structure/Serialized/Specifics'
local Command = require 'Structure/Serialized/Response'

local Constants = {
    apiUrl = 'https:discord.com/api/v10',

    gatewayPath = '/?v=10&encoding=json/',

    defaultDelay = 0.1, --// Default http delay in seconds
    defaultGatewayDelay = 0.5, --// Half second or 500 milliseconds

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

    gatewayDescription = {
        [0] = 'dispatch',
        [1] = 'heartbeat',
        [2] = 'identify',
        [3] = 'presenceUpdate',
        [4] = 'voiceStateUpdate',
        [6] = 'resume',
        [7] = 'reconnect',
        [8] = 'requestGuildMembers',
        [9] = 'invalid session',
        [10] = 'hello',
        [11] = 'heartbeatAck'
    },
    
    closeCodes = {
        [4000] = true,  --// Unknown error
        [4001] = true,  --// Unknown opcode
        [4002] = true,  --// Decode error
        [4003] = true,  --// Not authenticated
        [4004] = false, --// Authentication failed
        [4005] = true,  --// Already authenticated
        [4007] = true,  --// Invalid seq
        [4008] = true,  --// Rate limited
        [4009] = true,  --// Session timed out
        [4010] = 'error', --// Invalid shard
        [4011] = 'error', --// Sharding required
        [4012] = 'error', --// Invalid API version
        [4013] = 'error', --// Invalid intent(s)
        [4014] = 'error', --// Disallowed intent(s)
        [1000] = true,  --// Reconnect opcode
        [1001] = true   --// Reconnect opcode
    },

    closeErrors = {
        [4010] = 'Invalid shard',
        [4011] = 'Sharding required',
        [4012] = 'Invalid API version',
        [4013] = 'Invalid intent(s)',
        [4014] = 'Disallowed intent(s)',
        [4000] = 'Unknown error',
        [4001] = 'Unknown opcode',
        [4002] = 'Decode error',
        [4003] = 'Not authenticated',
        [4005] = 'Already authenticated',
        [4007] = 'Invalid seq',
        [4008] = 'Rate limited',
        [4009] = 'Session timed out'
    },

    payloads = {
        --// Messages
        MESSAGE_CREATE = Message,
        MESSAGE_UPDATE = Message,

        --// Guilds
        GUILD_CREATE = Guild,
        GUILD_UPDATE = Guild,
        GUILD_DELETE = Specifics,

        --// Member
        GUILD_MEMBER_ADD = Member,
        GUILD_MEMBER_UPDATE = Member,
        GUILD_MEMBER_REMOVE = Specifics,

        --// Ban
        GUILD_BAN_ADD = Specifics,
        GUILD_BAN_REMOVE = Specifics,

        --// Channel
        CHANNEL_CREATE = Channel,
        CHANNEL_UPDATE = Channel,
        CHANNEL_DELETE = Specifics,

        --// Thread
        THREAD_CREATE = Channel,
        THREAD_UPDATE = Channel,
        THREAD_DELETE = Specifics,

        --// Role
        GUILD_ROLE_CREATE = Role,
        GUILD_ROLE_UPDATE = Role,
        GUILD_ROLE_DELETE = Specifics,

        --// Commands
        INTERACTION_CREATE = Command,
    }
}

function Constants.identifyStructure()
    return {
        properties = {
            os = '',
            browser = 'Lumi',
            device = 'Lumi',
        },
        presence = {
            status = 'online',
            afk = false
        },
        intents = 4613
    }
end

function Constants.defaultHeaders(token: string)
    return {
        ['User-Agent'] = 'DiscordBot (https://github.com/astridyz/Lumi, 0.1.0)',
        ['Authorization'] = 'Bot ' .. token,
        ['Content-Type'] = 'application/json'
    }
end

return Constants