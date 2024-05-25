local Enums = {}

local function flag(n)
    return n^2
end

Enums.gatewayIntents = {
    -- guilds                  = flag(0), (Default intent)
    guildMembers            = flag(1), --// privileged
    -- guildModeration         = flag(2), (Default intent)
    guildEmojisAndStickers  = flag(3),
    guildIntegrations       = flag(4),
    guildWebhooks           = flag(5),
    guildInvites            = flag(6),
    guildVoiceStates        = flag(7),
    guildPresences          = flag(8), --// privileged
    -- guildMessages           = flag(9), (Default intent)
    guildMessageReactions   = flag(10),
    guildMessageTyping      = flag(11),
    -- directMessages          = flag(12), (Default intent)
    directMessageReactions  = flag(13),
    directMessageTyping     = flag(14),
    messageContent          = flag(15), --// privileged
    guildScheduledEvents    = flag(16),
    autoModConfiguration    = flag(20),
    autoModExecution        = flag(21),
    guildMessagePolls       = flag(24),
    directMessagePolls      = flag(25),
}


return Enums