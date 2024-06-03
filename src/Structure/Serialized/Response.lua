--// Requires
local Component = require '../../Component'

local Guild = require 'Guild'
local User = require 'User'
local Member = require 'Member'
local Channel = require 'Channel'

--// Types
type Data = Component.Data

type Guild = Guild.Guild
type User = User.User
type Member = Member.Member
type Channel = Channel.Channel

export type Response = {
    applicationID: string,
    token: string,
    ID: string,
    user: User?,
    guild: Guild?,
    channel: Channel,
    reply: (content: Data | string) -> string?
}

--[=[

    @class Command Response

    Represents a response to an application command.

]=]

--// This
return Component.wrap('Response', function(self, data, client, serializer): Response
    --// Public

    --[=[

        @within Command Response
        @prop applicationID string

        The unique identifier for the application.

    ]=]

    self.applicationID = data.application_id

    --[=[

        @within Command Response
        @prop token string

        The token for the interaction.

    ]=]

    self.token = data.token

    --[=[

        @within Command Response
        @prop ID string

        The unique identifier for the interaction.

    ]=]

    self.ID = data.id

    --[=[

        @within Command Response
        @prop user User?

        The user who triggered the interaction, if available.

    ]=]

    self.user = data.user and serializer.data(data.user, User)

    --[=[

        @within Command Response
        @prop guild Guild?

        The guild in which the interaction occurred, if available.

    ]=]

    self.guild = data.guild and client.state.getGuild(data.guild_id)
    
    --[=[

        @within Command Response
        @prop channel Channel

        The channel in which the interaction occurred.

    ]=]

    self.channel = data.channel and client.state.getChannel(data.channel_id)

    --[=[

        @within Command Response
        @param payload {} | string

        Sends a reply to the interaction. The content can be a string or a data object created by Lumi builders.

        @return (error: string?)

    ]=]

    function self.reply(payload: Data | string): string?
        return client.replyInteraction(self.ID, self.token, payload)
    end

    return self.query()
end)
