--!strict
--// This
local User = {}

function User.wrap(data, client, serializer): User
    local self = {} :: User

    --//Public
    self.prototype = 'User'
    self.ID = data.id
    self.username = data.username
    self.discriminator = data.discriminator
    self.nickname = data.global_name

    function self.mention(): string
        return string.format('<@%s>', self.ID)
    end

    return self
end

export type User = {
    prototype: string,
    ID: string,
    username: string,
    discriminator: string,
    nickname: string,
    mention: () -> ()
}

return User
