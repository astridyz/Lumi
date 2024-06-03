--!strict
--// Requires
local Component = require '../../Component'
local User = require 'User'
local Guild = require 'Guild'

--// Types
type User = User.User
type Guild = Guild.Guild

export type Member = {
    user: User?,
    guild: Guild?,
    nick: string,
}

--[=[
    
    @class Member

    Represents a member of a guild with properties for the user, guild, and nickname.

]=]

--// This
return Component.wrap('Member', function(self, data, client, serializer): Member
    --// Public

    --[=[

        @within Member
        @prop user User?

        The user associated with this member.

    ]=]

    self.user = data.user and serializer.data(data.user, User) or nil

    --[=[

        @within Member
        @prop nick string

        The nickname of the member in the guild.

    ]=]

    self.nick = data.nick

    --[=[

        @within Member
        @prop guild Guild?

        The guild to which the member belongs.

    ]=]

    self.guild = data.guild_id and client.state.getGuild(data.guild_id) or nil

    return self.query()
end)
