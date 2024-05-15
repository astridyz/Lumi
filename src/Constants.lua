local message = require 'Structure/Serialized/message'

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
    
    CLIENT_EVENTS = {
        hello = "HELLO",
        ready = "READY",
        resumed = "RESUMED",
        reconnect = "RECONNECT",
        invalidSession = "INVALID_SESSION",
        applicationCommandPermissionsUpdate = "APPLICATION_COMMAND_PERMISSIONS_UPDATE",
        autoModerationRuleCreate = "AUTO_MODERATION_RULE_CREATE",
        autoModerationRuleUpdate = "AUTO_MODERATION_RULE_UPDATE",
        autoModerationRuleDelete = "AUTO_MODERATION_RULE_DELETE",
        autoModerationActionExecution = "AUTO_MODERATION_ACTION_EXECUTION",
        channelCreate = "CHANNEL_CREATE",
        channelUpdate = "CHANNEL_UPDATE",
        channelDelete = "CHANNEL_DELETE",
        channelPinsUpdate = "CHANNEL_PINS_UPDATE",
        threadCreate = "THREAD_CREATE",
        threadUpdate = "THREAD_UPDATE",
        threadDelete = "THREAD_DELETE",
        threadListSync = "THREAD_LIST_SYNC",
        threadMemberUpdate = "THREAD_MEMBER_UPDATE",
        threadMembersUpdate = "THREAD_MEMBERS_UPDATE",
        entitlementCreate = "ENTITLEMENT_CREATE",
        entitlementUpdate = "ENTITLEMENT_UPDATE",
        entitlementDelete = "ENTITLEMENT_DELETE",
        guildCreate = "GUILD_CREATE",
        guildUpdate = "GUILD_UPDATE",
        guildDelete = "GUILD_DELETE",
        guildAuditLogEntryCreate = "GUILD_AUDIT_LOG_ENTRY_CREATE",
        guildBanAdd = "GUILD_BAN_ADD",
        guildBanRemove = "GUILD_BAN_REMOVE",
        guildEmojisUpdate = "GUILD_EMOJIS_UPDATE",
        guildStickersUpdate = "GUILD_STICKERS_UPDATE",
        guildIntegrationsUpdate = "GUILD_INTEGRATIONS_UPDATE",
        guildMemberAdd = "GUILD_MEMBER_ADD",
        guildMemberRemove = "GUILD_MEMBER_REMOVE",
        guildMemberUpdate = "GUILD_MEMBER_UPDATE",
        guildMembersChunk = "GUILD_MEMBERS_CHUNK",
        guildRoleCreate = "GUILD_ROLE_CREATE",
        guildRoleUpdate = "GUILD_ROLE_UPDATE",
        guildRoleDelete = "GUILD_ROLE_DELETE",
        guildScheduledEventCreate = "GUILD_SCHEDULED_EVENT_CREATE",
        guildScheduledEventUpdate = "GUILD_SCHEDULED_EVENT_UPDATE",
        guildScheduledEventDelete = "GUILD_SCHEDULED_EVENT_DELETE",
        guildScheduledEventUserAdd = "GUILD_SCHEDULED_EVENT_USER_ADD",
        guildScheduledEventUserRemove = "GUILD_SCHEDULED_EVENT_USER_REMOVE",
        integrationCreate = "INTEGRATION_CREATE",
        integrationUpdate = "INTEGRATION_UPDATE",
        integrationDelete = "INTEGRATION_DELETE",
        interactionCreate = "INTERACTION_CREATE",
        inviteCreate = "INVITE_CREATE",
        inviteDelete = "INVITE_DELETE",
        messageCreate = "MESSAGE_CREATE",
        messageUpdate = "MESSAGE_UPDATE",
        messageDelete = "MESSAGE_DELETE",
        messageDeleteBulk = "MESSAGE_DELETE_BULK",
        messageReactionAdd = "MESSAGE_REACTION_ADD",
        messageReactionRemove = "MESSAGE_REACTION_REMOVE",
        messageReactionRemoveAll = "MESSAGE_REACTION_REMOVE_ALL",
        messageReactionRemoveEmoji = "MESSAGE_REACTION_REMOVE_EMOJI",
        presenceUpdate = "PRESENCE_UPDATE",
        stageInstanceCreate = "STAGE_INSTANCE_CREATE",
        stageInstanceUpdate = "STAGE_INSTANCE_UPDATE",
        stageInstanceDelete = "STAGE_INSTANCE_DELETE",
        typingStart = "TYPING_START",
        userUpdate = "USER_UPDATE",
        voiceStateUpdate = "VOICE_STATE_UPDATE",
        voiceServerUpdate = "VOICE_SERVER_UPDATE",
        webhooksUpdate = "WEBHOOKS_UPDATE",
        messagePollVoteAdd = "MESSAGE_POLL_VOTE_ADD",
        messagePollVoteRemove = "MESSAGE_POLL_VOTE_REMOVE"
    },

    GATEWAY_EVENTS = {
        HELLO = "hello",
        READY = "ready",
        RESUMED = "resumed",
        RECONNECT = "reconnect",
        INVALID_SESSION = "invalidSession",
        APPLICATION_COMMAND_PERMISSIONS_UPDATE = "applicationCommandPermissionsUpdate",
        AUTO_MODERATION_RULE_CREATE = "autoModerationRuleCreate",
        AUTO_MODERATION_RULE_UPDATE = "autoModerationRuleUpdate",
        AUTO_MODERATION_RULE_DELETE = "autoModerationRuleDelete",
        AUTO_MODERATION_ACTION_EXECUTION = "autoModerationActionExecution",
        CHANNEL_CREATE = "channelCreate",
        CHANNEL_UPDATE = "channelUpdate",
        CHANNEL_DELETE = "channelDelete",
        CHANNEL_PINS_UPDATE = "channelPinsUpdate",
        THREAD_CREATE = "threadCreate",
        THREAD_UPDATE = "threadUpdate",
        THREAD_DELETE = "threadDelete",
        THREAD_LIST_SYNC = "threadListSync",
        THREAD_MEMBER_UPDATE = "threadMemberUpdate",
        THREAD_MEMBERS_UPDATE = "threadMembersUpdate",
        ENTITLEMENT_CREATE = "entitlementCreate",
        ENTITLEMENT_UPDATE = "entitlementUpdate",
        ENTITLEMENT_DELETE = "entitlementDelete",
        GUILD_CREATE = "guildCreate",
        GUILD_UPDATE = "guildUpdate",
        GUILD_DELETE = "guildDelete",
        GUILD_AUDIT_LOG_ENTRY_CREATE = "guildAuditLogEntryCreate",
        GUILD_BAN_ADD = "guildBanAdd",
        GUILD_BAN_REMOVE = "guildBanRemove",
        GUILD_EMOJIS_UPDATE = "guildEmojisUpdate",
        GUILD_STICKERS_UPDATE = "guildStickersUpdate",
        GUILD_INTEGRATIONS_UPDATE = "guildIntegrationsUpdate",
        GUILD_MEMBER_ADD = "guildMemberAdd",
        GUILD_MEMBER_REMOVE = "guildMemberRemove",
        GUILD_MEMBER_UPDATE = "guildMemberUpdate",
        GUILD_MEMBERS_CHUNK = "guildMembersChunk",
        GUILD_ROLE_CREATE = "guildRoleCreate",
        GUILD_ROLE_UPDATE = "guildRoleUpdate",
        GUILD_ROLE_DELETE = "guildRoleDelete",
        GUILD_SCHEDULED_EVENT_CREATE = "guildScheduledEventCreate",
        GUILD_SCHEDULED_EVENT_UPDATE = "guildScheduledEventUpdate",
        GUILD_SCHEDULED_EVENT_DELETE = "guildScheduledEventDelete",
        GUILD_SCHEDULED_EVENT_USER_ADD = "guildScheduledEventUserAdd",
        GUILD_SCHEDULED_EVENT_USER_REMOVE = "guildScheduledEventUserRemove",
        INTEGRATION_CREATE = "integrationCreate",
        INTEGRATION_UPDATE = "integrationUpdate",
        INTEGRATION_DELETE = "integrationDelete",
        INTERACTION_CREATE = "interactionCreate",
        INVITE_CREATE = "inviteCreate",
        INVITE_DELETE = "inviteDelete",
        MESSAGE_CREATE = "messageCreate",
        MESSAGE_UPDATE = "messageUpdate",
        MESSAGE_DELETE = "messageDelete",
        MESSAGE_DELETE_BULK = "messageDeleteBulk",
        MESSAGE_REACTION_ADD = "messageReactionAdd",
        MESSAGE_REACTION_REMOVE = "messageReactionRemove",
        MESSAGE_REACTION_REMOVE_ALL = "messageReactionRemoveAll",
        MESSAGE_REACTION_REMOVE_EMOJI = "messageReactionRemoveEmoji",
        PRESENCE_UPDATE = "presenceUpdate",
        STAGE_INSTANCE_CREATE = "stageInstanceCreate",
        STAGE_INSTANCE_UPDATE = "stageInstanceUpdate",
        STAGE_INSTANCE_DELETE = "stageInstanceDelete",
        TYPING_START = "typingStart",
        USER_UPDATE = "userUpdate",
        VOICE_STATE_UPDATE = "voiceStateUpdate",
        VOICE_SERVER_UPDATE = "voiceServerUpdate",
        WEBHOOKS_UPDATE = "webhooksUpdate",
        MESSAGE_POLL_VOTE_ADD = "messagePollVoteAdd",
        MESSAGE_POLL_VOTE_REMOVE = "messagePollVoteRemove"
    },

    PAYLOADS = {
        MESSAGE_CREATE = message
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