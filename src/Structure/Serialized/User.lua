--!strict
--// Requires
local Lumi = require '../../Lumi'

--// Types
export type User = {
    ID: string,
    username: string,
    discriminator: string,
    nickname: string,
    mention: () -> string
}

--// This
return Lumi.container('User', function(self, data): User
    --//Public
    self.ID = data.id
    self.username = data.username
    self.discriminator = data.discriminator
    self.nickname = data.global_name

    --// Methods
    function self.mention(): string
        return string.format('<@%s>', self.ID)
    end

    return self
end)