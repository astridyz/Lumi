--!strict
--// Requires
local Lumi = require '../../Lumi'

--// Types
export type Role = {
    guildID: string?,
    ID: string,
    name: string,
    intColor: number,
    managed: boolean,
    mentionable: boolean,
}

--[=[

    @within Containers
    @interface Role
    .ID string
    .name string
    .intColor number
    .managed boolean
    .mentionable boolean

]=]

--//This
return Lumi.container('Role', function(self, data, client, _): Role
    --// Public

    --// Role create
    if data.role then
        self.guildID = data.guild_id

        data = data.role
        
        local Guild = client.state.getGuild(self.guildID)
        Guild.roles.set(data.id, self)
    end

    self.ID = data.id
    self.name = data.name
    self.intColor = data.color
    self.managed = data.managed
    self.mentionable = data.mentionable

    return self
end)
