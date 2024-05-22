--!strict
--// Requires
local Lumi = require '../../Lumi'

local User = require 'User'
local Member = require 'Member'
local Guild = require 'Guild'
local Channel = require 'Channel'

--// Types
type Data = Lumi.Data

type User = User.User
type Member = Member.Member
type Guild = Guild.Guild
type Channel = Channel.Channel

export type Message = {
    author: User,
    member: Member,
    guild: Guild,
    ID: string,
    everyone: boolean,
    channel: Channel,
    content: string,
    respond: (content: any) -> (string?),
    reply: (content: any) -> (string?)
}

--[=[

    @within Containers
    @interface Message
    .author User
    .member Member?
    .guild Guild?
    .ID string
    .everyone boolean
    .channel Channel
    .content string
    .respond (content: {} | string) -> (error: string?) -- Send a message in the current channel
    .reply (content: {} | string) -> (error: string?) -- Send a message replying to the message returned by messageCreate event

]=]

--// This
return Lumi.container('Message', function(self, data, client, serializer): Message
    --// Public
    self.ID = data.id
    self.everyone = data.mention_everyone
    self.content = data.content

    self.channel =  client.state.getChannel(data.channel_id) or nil
    self.author = serializer.data(data.author, User)
    self.guild = data.guild_id and client.state.getGuild(data.guild_id) or nil
    self.member = serializer.data(data.member, Member) or nil

    --// Methods
    function self.respond(content: any)
        return client.sendMessage(self.channel.ID, content)
    end

    function self.reply(content: any)
        return client.sendMessage(self.channel.ID, {
            content = content,
            message_reference = {message_id = self.ID}
        })
    end

    return self
end)