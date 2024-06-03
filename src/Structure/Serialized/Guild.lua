--!strict
--// Requires
local Component = require '../../Component'

local Cache = require '../Cache'

local Channel = require 'Channel'
local Role = require 'Role'

--// Types
type Cache<asyncs> = Cache.Cache<asyncs>

type Channel = Channel.Channel
type Role = Role.Role

export type Guild = {
    members: number?,
    ID: number,
    name: string?,
    description: string?,
    locale: string?,
    channels: Cache<Channel>,
    roles: Cache<Role>
}

--[=[
    @class Guild

    Represents a Discord guild object.

]=]

--// This
return Component.wrap('Guild', function(self, data, client, serializer): Guild
    --// Public

    --[=[

        @within Guild
        @prop members number?

        The number of members in the guild.

    ]=]

    self.members = data.member_count

    --[=[

        @within Guild
        @prop ID number

        The unique identifier for the guild.

    ]=]

    self.ID = data.id

    --[=[

        @within Guild
        @prop name string?

        The name of the guild.

    ]=]

    self.name = data.name

    --[=[

        @within Guild
        @prop description string?

        The description of the guild.

    ]=]

    self.description = data.description

    --[=[

        @within Guild
        @prop locale string?

        The preferred locale of the guild.

    ]=]

    self.locale = data.preferred_locale

    --[=[

        @within Guild
        @prop channels Cache<Channel>

        A cache containing the channels of the guild.

    ]=]

    self.channels = Cache('myChannel', 'k', Channel)

    --[=[

        @within Guild
        @prop roles Cache<Role>

        A cache containing the roles of the guild.

    ]=]

    self.roles = Cache('myRole', 'k', Role)

    --// Serializating data inside the payload.
    if data.channels then
        for _, channel in ipairs(data.channels) do
            channel = serializer.data(channel, Channel)
            self.channels.set(channel.ID, channel)
        end
    end

    for _, thread in ipairs(data.threads) do
        thread = serializer.data(thread, Channel)
        self.channels.set(thread.ID, thread)
    end

    for _, role in ipairs(data.roles) do
        role = serializer.data(role, Role :: any)
        self.roles.set(role.ID, role)
    end

    return self.query()
end)
