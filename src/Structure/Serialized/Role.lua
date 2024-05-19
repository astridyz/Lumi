--!strict
--// Requires
local Lumi = require '../../Lumi'

--// Types
export type Role = {
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
return Lumi.container('Role', function(self, data, _, _): Role
    --// Public
    self.ID = data.id
    self.name = data.name
    self.intColor = data.color
    self.managed = data.managed
    self.mentionable = data.mentionable

    return self
end)
