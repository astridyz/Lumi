--!strict
--// Requires
local User = require 'User'
local Guild = require 'Guild'

--// This
local Member = {}

function Member.wrap(data, client, serializer): Member
    local self = {} :: Member

    self.prototype = 'Member'
    self.user = data.user and serializer.data(data.user, User) or nil
    self.nickname = data.nick
    self.guild = data.guild_id and data.guild_id or nil

    return self
end

export type Member = {
    prototype: string,
    user: User?,
    guild: Guild?,
    nickname: string,
}

type User = User.User
type Guild = Guild.Guild

return Member