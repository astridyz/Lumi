--!strict
--// Requires
local Lumi = require '../../Lumi'

--// Types
type Data = Lumi.Data

export type Channel = {
    ID: string,
    type: string,
    name: string,
    guildID: string,
    topic: string,
    nsfw: boolean,
    slowmode: number,
    parentID: number,
    newlyCreated: boolean,
    sendMessage: (content: string | Data) -> (string?)
}

--[=[

    @within Containers
    @interface Channel
    .name string
    .ID string
    .type string
    .guildID string
    .topic string
    .nsfw boolean
    .slowmode number
    .parentID number
    .newlyCreated boolean
    .sendMessage (content: string | {}) -> (error: string?)

]=]

--//This
return Lumi.container('Channel', function(self, data, client): Channel
    --// Public
    self.ID = data.id
    self.guildID = data.guild_id
    self.name = data.name
    self.topic = data.topic
    self.nsfw = data.nsfw
    self.slowmode = data.rate_limit_per_users
    self.parentID = data.parent_id
    self.newlyCreated = data.newly_created

    --// Methods
    function self.sendMessage(content: string | Data)
        return client.sendMessage(self.ID, content)
    end

    return self
end)
