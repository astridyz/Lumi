--!strict
--// Requires
local Lumi = require '../../Lumi'

--// Types
export type User = {
    ID: string,
    username: string,
    discriminator: string,
    nickname: string,
    isBot: boolean,
    mention: () -> string
}

--[=[

    @within Containers
    @interface User
    .ID string
    .username String
    .discriminator string -- Discriminators are deprecated
    .nickname string
    .isBot boolean
    .mention () -> string -- Returns a formated mentioning string

]=]

--// This
return Lumi.container('User', function(self, data): User
    --//Public
    self.ID = data.id
    self.username = data.username
    self.discriminator = data.discriminator
    self.nickname = data.global_name
    self.isBot = data.bot

    --// Methods
    function self.mention(): string
        return string.format('<@%s>', self.ID)
    end

    return self
end)