--!strict
--// Requires
local Component = require '../../Component'

--// Types
type Data = Component.Data

export type Channel = {
    ID: string,
    type: string,
    name: string,
    guildID: string?,
    topic: string,
    nsfw: boolean,
    slowmode: number,
    parentID: number,
    newlyCreated: boolean,
    send: (content: string | Data) -> (string?)
}

--[=[

    @class Channel

    Represents a Discord channel object.

]=]

--// This
return Component.wrap('Channel', function(self, data, client): Channel
    --// Public

    --[=[

        @within Channel
        @prop ID string

        The unique identifier for the channel.

    ]=]
    
    self.ID = data.id

    --[=[

        @within Channel
        @prop type string

        The type of the channel (e.g., text, voice).

    ]=]

    self.type = data.type

    --[=[

        @within Channel
        @prop name string

        The name of the channel.

    ]=]

    self.name = data.name

    --[=[

        @within Channel
        @prop guildID string?

        The unique identifier for the guild (server) this channel belongs to.

    ]=]

    self.guildID = data.guild_id

    --// Adding this channel to the guild cache it belongs to.
    if self.guildID then
        local Guild = client.state.getGuild(self.guildID)
        Guild.roles.set(self.ID, self)
    end

    --[=[

        @within Channel
        @prop topic string

        The topic of the channel.

    ]=]

    self.topic = data.topic

    --[=[

        @within Channel
        @prop nsfw boolean

        Indicates if the channel is marked as NSFW (Not Safe For Work).

    ]=]

    self.nsfw = data.nsfw

    --[=[

        @within Channel
        @prop slowmode number

        The slowmode delay in seconds.

    ]=]

    self.slowmode = data.rate_limit_per_users

    --[=[

        @within Channel
        @prop parentID number

        The unique identifier for the parent category of the channel.

    ]=]

    self.parentID = data.parent_id

    --[=[

        @within Channel
        @prop newlyCreated boolean

        Indicates if the channel was newly created.

    ]=]

    self.newlyCreated = data.newly_created

    --[=[

        @within Channel
        @param content string | {}

        Sends a message in the channel. The content can be a string or a data object created by Lumi builders.

        @return (error: string?)

    ]=]

    function self.send(content: string | Data)
        return client.send(self.ID, content)
    end

    return self.query()
end)
