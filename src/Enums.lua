--// This
local Enums = {}

--// Functions
local function flag(n)
    return 2^n
end

--// Types
export type ApplicationCommandType = number
export type InteractionContextType = number
export type ApplicationCommandOptionType = number

--// Enums
Enums.gatewayIntents = {
    -- guilds               = flag(0), (Default intent)
    guildMembers            = flag(1), --// privileged
    -- guildModeration      = flag(2), (Default intent)
    guildEmojisAndStickers  = flag(3),
    guildIntegrations       = flag(4),
    guildWebhooks           = flag(5),
    guildInvites            = flag(6),
    guildVoiceStates        = flag(7),
    guildPresences          = flag(8), --// privileged
    -- guildMessages        = flag(9), (Default intent)
    guildMessageReactions   = flag(10),
    guildMessageTyping      = flag(11),
    -- directMessages       = flag(12), (Default intent)
    directMessageReactions  = flag(13),
    directMessageTyping     = flag(14),
    messageContent          = flag(15), --// privileged
    guildScheduledEvents    = flag(16),
    autoModConfiguration    = flag(20),
    autoModExecution        = flag(21),
    guildMessagePolls       = flag(24),
    directMessagePolls      = flag(25),
}

Enums.applicationCommandTypes = {
    chatInput = 1,
    user = 2,
    slash = 3
} :: {
    chatInput: ApplicationCommandType,
    user: ApplicationCommandType,
    slash: ApplicationCommandType
}

Enums.InteractionContextTypes = {
    guild = 0,
    botDm = 1,
    privateChannel = 2
} :: {
    guild: InteractionContextType,
    botDm: InteractionContextType,
    privateChannel: InteractionContextType
}

Enums.ApplicationCommandOptionTypes = {
    subCommand = 1,
    subCommandGroup = 2,
    string = 3,
    integer = 4,
    boolean = 5,
    user = 6,
    channel = 7,
    role = 8,
    mentionable = 9,
    number = 10,
    -- attachment = 11 (Lumi doesnt support attachments yet)
} :: {
    subCommand: ApplicationCommandOptionType,
    subCommandGroup: ApplicationCommandOptionType,
    string: ApplicationCommandOptionType,
    integer: ApplicationCommandOptionType,
    boolean: ApplicationCommandOptionType,
    user: ApplicationCommandOptionType,
    channel: ApplicationCommandOptionType,
    role: ApplicationCommandOptionType,
    mentionable: ApplicationCommandOptionType,
    number: ApplicationCommandOptionType
}

return Enums