--!strict
--// Requires
local Lumi = require '../../Lumi'

--// Types
export type Guild = {
    container: string?,
    members: number?,
    ID: number,
    name: string?,
    description: string?,
    locale: string?
}

--// This
return Lumi.container('Guild', function(self, data, client, _): Guild
    --// Public
    self.members = data.member_count or nil
    self.ID = data.id or nil
    self.name = data.name or nil
    self.description = data.description or nil
    self.locale = data.preferred_locale or nil

    return self
end)