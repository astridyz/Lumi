type Token = string

return {
    defaultIdentify = function(token : Token): {[string] : string | {[string] : any} | boolean}
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
    end,

    API_URL = 'https://discord.com/api/v10',
    
    USER_AGENT = string.format('DiscordBot (%s, %s)', 'https://github.com/astridyz/Luthe', '0.1.0'),

    GATEWAY_PATH = '/?v=10&encoding=json/',

    gatewayCodes = {
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

    eventsName = {
        
    }
}