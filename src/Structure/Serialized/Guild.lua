--!strict
--// Requires
local Lumi = require '../../Lumi'
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

    @within Containers
    @interface Guild
    .members number
    .ID string
    .name string
    .description string
    .locale string
    .channels Cache<Channel>
    .roles Cache<Role>

]=]

--// This
return Lumi.container('Guild', function(self, data, client, serializer): Guild
    --// Public
    self.members = data.member_count or nil
    self.ID = data.id or nil
    self.name = data.name or nil
    self.description = data.description or nil
    self.locale = data.preferred_locale or nil

    self.channels = Cache('myChannel', 'k', Channel)

    if data.channels then
        for _, channel in ipairs(data.channels) do
            channel = serializer.data(channel, Channel)
            self.channels.set(channel.ID, channel)
        end
    end

    self.roles = Cache('myRole', 'k', Role)

    for _, role in ipairs(data.roles) do
        role = serializer.data(role, Role)
        self.roles.set(role.ID, role)
    end

    return self
end)