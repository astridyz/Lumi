--// Requires
local Lumi = require '../../Lumi'

--// Types
type Data = Lumi.Data

export type Application = {
    ID: string,
    name: string,
    description: string,
    isPublic: boolean
}

--// This
return Lumi.container('Application', function(self, data): Application

    self.ID = data.id
    self.name = data.name
    self.description = data.description
    self.isPublic = data.bot_public

    return self
end)
