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
    
    @class Role

    Represents a Discord role object.

]=]

--// This
return Lumi.container('Role', function(self, data, client, _): Role
    --// Public

    --[=[
        
        @within Role
        @prop guildID string?

        The ID of the guild to which the role belongs.

    ]=]

    if data.role then
        self.guildID = data.guild_id

        data = data.role
        
        local Guild = client.state.getGuild(self.guildID)
        Guild.roles.set(data.id, self)
    end

    --[=[

        @within Role
        @prop ID string

        The unique identifier for the role.

    ]=]

    self.ID = data.id

    --[=[

        @within Role
        @prop name string

        The name of the role.

    ]=]

    self.name = data.name

    --[=[

        @within Role
        @prop intColor number

        The color of the role represented as an integer.

    ]=]

    self.intColor = data.color

    --[=[

        @within Role
        @prop managed boolean

        Whether the role is managed by an integration.

    ]=]

    self.managed = data.managed

    --[=[

        @within Role
        @prop mentionable boolean

        Whether the role is mentionable.

    ]=]

    self.mentionable = data.mentionable

    return self
end)
