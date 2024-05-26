--// Requires
local Lumi = require '../../Lumi'

local Guild = require 'Guild'
local User = require 'User'
local Member = require 'Member'

local Channel = require 'Channel'

--// Types
type Data = Lumi.Data

type Guild = Guild.Guild
type User = User.User
type Member = Member.Member
type Channel = Channel.Channel

export type ApplicationCommandResponse = {
    applicationID: string,
    token: string,
    ID: string,
    user: User?,
    guild: Guild?,
    channel: Channel,

    reply: (content: Data | string) -> ()
}

--// This
return Lumi.container('ApplicationCommandResponse', function(self, data, client, serializer): ApplicationCommandResponse
    --// Public'
    self.token = data.token
    self.ID = data.id
    self.applicationID = data.application_id

    self.guild = data.guild and client.state.getGuild(data.guild_id)

    self.user = data.user and serializer.data(data.user, User)
    self.channel = data.channel and client.state.getChannel(data.channel_id)

    function self.reply(payload: Data | string)
        return client.replyInteraction(self.ID, self.token, payload)
    end

    return self
end)
