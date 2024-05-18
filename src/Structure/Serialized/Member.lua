--!strict
--// Requires
local Lumi = require '../../Lumi'
local User = require 'User'
local Guild = require 'Guild'

--// Types
type User = User.User
type Guild = Guild.Guild

export type Member = {
    user: User?,
    guild: Guild?,
    nickname: string,
}

--// This
return Lumi.container('Member', function(self, data, _, serializer): Member
    --// Public
    self.user = data.user and serializer.data(data.user, User) or nil
    self.nickname = data.nick
    self.guild = data.guild_id and data.guild_id or nil

    return self
end)