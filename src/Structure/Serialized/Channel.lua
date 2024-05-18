--!strict
--// Requires
local Lumi = require '../../Lumi'

--// Types
export type Channel = {
    ID: string,
    type: string,
    name: string,
    guild: string,
    topic: string,
    nsfw: boolean,
    slowmode: number,
    parentID: number,
}

--//This
return Lumi.container('Channel', function(self, data): Channel
    --// Public
    self.ID = data.id
    self.guildID = data.guild_id or nil
    self.name = data.name
    self.topic = data.topic
    self.nsfw = data.nsfw
    self.slowmode = data.rate_limit_per_user
    self.parentID = data.parent_id

    return self
end)
