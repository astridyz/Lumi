type Token = string

return {
    defaultIdentify = function(token : Token): {[string] : string | {[string] : any} | boolean}
        return {
            ['token'] = token,
            ['properties'] = {
                ['os'] = '',
                ['browser'] = 'Lumi',
                ['device'] = 'Lumi',
            },
            ['presence'] = {
                ['status'] = 'online',
                ['afk'] = false
            },
            ['intents'] = 0
        }
    end,

    API_URL = 'https://discord.com/api/v10',
    
    USER_AGENT = string.format('DiscordBot (%s, %s)', 'https://github.com/astridyz/Luthe', '0.1.0'),

    GATEWAY_PATH = '/?v=10&encoding=json/'
}