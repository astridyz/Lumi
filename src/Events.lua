local Message = require 'Structure/Serialized/message'
type Message = Message.Message

local Guild = require 'Structure/Serialized/Guild'
type Guild = Guild.Guild

local Channel = require 'Structure/Serialized/Channel'
type Channel = Channel.Channel

local User = require 'Structure/Serialized/User'
type User = User.User

local Member = require 'Structure/Serialized/Member'
type Member = Member.Member

local Role = require 'Structure/Serialized/Role'
type Role = Role.Role

local Command = require 'Structure/Serialized/Response'
type ApplicationCommand = Command.Response

export type Event<args...> = {
    payload: (args...) -> (),
    index: string,
    name: string
}

return {
    ready = {
        payload = function() end,
        name = "READY",
        index = "ready"
    },
    resumed = {
        payload = function() end,
        name = "RESUMED",
        index = "resumed"
    },
    reconnect = {
        payload = function() end,
        name = "RECONNECT",
        index = "reconnect"
    },
    applicationCommandPermissionsUpdate = {
        payload = {},
        name = "APPLICATION_COMMAND_PERMISSIONS_UPDATE",
        index = "applicationCommandPermissionsUpdate"
    },
    autoModerationRuleCreate = {
        payload = {},
        name = "AUTO_MODERATION_RULE_CREATE",
        index = "autoModerationRuleCreate"
    },
    autoModerationRuleUpdate = {
        payload = {},
        name = "AUTO_MODERATION_RULE_UPDATE",
        index = "autoModerationRuleUpdate"
    },
    autoModerationRuleDelete = {
        payload = {},
        name = "AUTO_MODERATION_RULE_DELETE",
        index = "autoModerationRuleDelete"
    },
    autoModerationActionExecution = {
        payload = {},
        name = "AUTO_MODERATION_ACTION_EXECUTION",
        index = "autoModerationActionExecution"
    },
    channelCreate = {
        payload = function(Channel: Channel) end,
        name = "CHANNEL_CREATE",
        index = "channelCreate"
    },
    channelUpdate = {
        payload = function(Channel: Channel) end,
        name = "CHANNEL_UPDATE",
        index = "channelUpdate"
    },
    channelDelete = {
        payload = function(data: {ID: string, guild: Guild}) end,
        name = "CHANNEL_DELETE",
        index = "channelDelete"
    },
    channelPinsUpdate = {
        payload = {},
        name = "CHANNEL_PINS_UPDATE",
        index = "channelPinsUpdate"
    },
    threadCreate = {
        payload = function(Channel: Channel) end,
        name = "THREAD_CREATE",
        index = "threadCreate"
    },
    threadUpdate = {
        payload = function(Channel: Channel) end,
        name = "THREAD_UPDATE",
        index = "threadUpdate"
    },
    threadDelete = {
        payload = function(data: {ID: string, guild: Guild}) end,
        name = "THREAD_DELETE",
        index = "threadDelete"
    },
    threadListSync = {
        payload = {},
        name = "THREAD_LIST_SYNC",
        index = "threadListSync"
    },
    threadMemberUpdate = {
        payload = {},
        name = "THREAD_MEMBER_UPDATE",
        index = "threadMemberUpdate"
    },
    threadMembersUpdate = {
        payload = {},
        name = "THREAD_MEMBERS_UPDATE",
        index = "threadMembersUpdate"
    },
    entitlementCreate = {
        payload = {},
        name = "ENTITLEMENT_CREATE",
        index = "entitlementCreate"
    },
    entitlementUpdate = {
        payload = {},
        name = "ENTITLEMENT_UPDATE",
        index = "entitlementUpdate"
    },
    entitlementDelete = {
        payload = {},
        name = "ENTITLEMENT_DELETE",
        index = "entitlementDelete"
    },
    guildCreate = {
        payload = function(Guild: Guild) end,
        name = "GUILD_CREATE",
        index = "guildCreate"
    },
    guildUpdate = {
        payload = function(Guild: Guild) end,
        name = "GUILD_UPDATE",
        index = "guildUpdate"
    },
    guildDelete = {
        payload = function(data: {ID: string}) end,
        name = "GUILD_DELETE",
        index = "guildDelete"
    },
    guildAuditLogEntryCreate = {
        payload = {},
        name = "GUILD_AUDIT_LOG_ENTRY_CREATE",
        index = "guildAuditLogEntryCreate"
    },
    guildBanAdd = {
        payload = function(data: {guild: Guild, user: User}) end,
        name = "GUILD_BAN_ADD",
        index = "guildBanAdd"
    },
    guildBanRemove = {
        payload = function(data: {guild: Guild, user: User}) end,
        name = "GUILD_BAN_REMOVE",
        index = "guildBanRemove"
    },
    guildEmojisUpdate = {
        payload = {},
        name = "GUILD_EMOJIS_UPDATE",
        index = "guildEmojisUpdate"
    },
    guildStickersUpdate = {
        payload = {},
        name = "GUILD_STICKERS_UPDATE",
        index = "guildStickersUpdate"
    },
    guildIntegrationsUpdate = {
        payload = {},
        name = "GUILD_INTEGRATIONS_UPDATE",
        index = "guildIntegrationsUpdate"
    },
    guildMemberAdd = {
        payload = function(Member: Member) end,
        name = "GUILD_MEMBER_ADD",
        index = "guildMemberAdd"
    },
    guildMemberRemove = {
        payload = function(data: {guild: Guild, user: User}) end,
        name = "GUILD_MEMBER_REMOVE",
        index = "guildMemberRemove"
    },
    guildMemberUpdate = {
        payload = function(Member: Member) end,
        name = "GUILD_MEMBER_UPDATE",
        index = "guildMemberUpdate"
    },
    guildMembersChunk = {
        payload = {},
        name = "GUILD_MEMBERS_CHUNK",
        index = "guildMembersChunk"
    },
    guildRoleCreate = {
        payload = function(role: Role) end,
        name = "GUILD_ROLE_CREATE",
        index = "guildRoleCreate"
    },
    guildRoleUpdate = {
        payload = function(role: Role) end,
        name = "GUILD_ROLE_UPDATE",
        index = "guildRoleUpdate"
    },
    guildRoleDelete = {
        payload = function(data: {ID: string, guild: Guild}) end,
        name = "GUILD_ROLE_DELETE",
        index = "guildRoleDelete"
    },
    guildScheduledEventCreate = {
        payload = {},
        name = "GUILD_SCHEDULED_EVENT_CREATE",
        index = "guildScheduledEventCreate"
    },
    guildScheduledEventUpdate = {
        payload = {},
        name = "GUILD_SCHEDULED_EVENT_UPDATE",
        index = "guildScheduledEventUpdate"
    },
    guildScheduledEventDelete = {
        payload = {},
        name = "GUILD_SCHEDULED_EVENT_DELETE",
        index = "guildScheduledEventDelete"
    },
    guildScheduledEventUserAdd = {
        payload = {},
        name = "GUILD_SCHEDULED_EVENT_USER_ADD",
        index = "guildScheduledEventUserAdd"
    },
    guildScheduledEventUserRemove = {
        payload = {},
        name = "GUILD_SCHEDULED_EVENT_USER_REMOVE",
        index = "guildScheduledEventUserRemove"
    },
    integrationCreate = {
        payload = {},
        name = "INTEGRATION_CREATE",
        index = "integrationCreate"
    },
    integrationUpdate = {
        payload = {},
        name = "INTEGRATION_UPDATE",
        index = "integrationUpdate"
    },
    integrationDelete = {
        payload = {},
        name = "INTEGRATION_DELETE",
        index = "integrationDelete"
    },
    interactionCreate = {
        payload = function(Interaction: ApplicationCommand) end,
        name = "INTERACTION_CREATE",
        index = "interactionCreate"
    },
    inviteCreate = {
        payload = {},
        name = "INVITE_CREATE",
        index = "inviteCreate"
    },
    inviteDelete = {
        payload = {},
        name = "INVITE_DELETE",
        index = "inviteDelete"
    },
    messageCreate = {
        payload = function(message: Message) end,
        name = "MESSAGE_CREATE",
        index = "messageCreate"
    },
    messageUpdate = {
        payload = function(message: Message) end,
        name = "MESSAGE_UPDATE",
        index = "messageUpdate"
    },
    messageDelete = {
        payload = {},
        name = "MESSAGE_DELETE",
        index = "messageDelete"
    },
    messageDeleteBulk = {
        payload = {},
        name = "MESSAGE_DELETE_BULK",
        index = "messageDeleteBulk"
    },
    messageReactionAdd = {
        payload = {},
        name = "MESSAGE_REACTION_ADD",
        index = "messageReactionAdd"
    },
    messageReactionRemove = {
        payload = {},
        name = "MESSAGE_REACTION_REMOVE",
        index = "messageReactionRemove"
    },
    messageReactionRemoveAll = {
        payload = {},
        name = "MESSAGE_REACTION_REMOVE_ALL",
        index = "messageReactionRemoveAll"
    },
    messageReactionRemoveEmoji = {
        payload = {},
        name = "MESSAGE_REACTION_REMOVE_EMOJI",
        index = "messageReactionRemoveEmoji"
    },
    presenceUpdate = {
        payload = {},
        name = "PRESENCE_UPDATE",
        index = "presenceUpdate"
    },
    stageInstanceCreate = {
        payload = {},
        name = "STAGE_INSTANCE_CREATE",
        index = "stageInstanceCreate"
    },
    stageInstanceUpdate = {
        payload = {},
        name = "STAGE_INSTANCE_UPDATE",
        index = "stageInstanceUpdate"
    },
    stageInstanceDelete = {
        payload = {},
        name = "STAGE_INSTANCE_DELETE",
        index = "stageInstanceDelete"
    },
    typingStart = {
        payload = {},
        name = "TYPING_START",
        index = "typingStart"
    },
    userUpdate = {
        payload = {},
        name = "USER_UPDATE",
        index = "userUpdate"
    },
    voiceStateUpdate = {
        payload = {},
        name = "VOICE_STATE_UPDATE",
        index = "voiceStateUpdate"
    },
    voiceServerUpdate = {
        payload = {},
        name = "VOICE_SERVER_UPDATE",
        index = "voiceServerUpdate"
    },
    webhooksUpdate = {
        payload = {},
        name = "WEBHOOKS_UPDATE",
        index = "webhooksUpdate"
    },
    messagePollVoteAdd = {
        payload = {},
        name = "MESSAGE_POLL_VOTE_ADD",
        index = "messagePollVoteAdd"
    },
    messagePollVoteRemove = {
        payload = {},
        name = "MESSAGE_POLL_VOTE_REMOVE",
        index = "messagePollVoteRemove"
    }
}