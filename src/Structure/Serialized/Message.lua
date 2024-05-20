--!strict
--// Requires
local Lumi = require '../../Lumi'
local User = require 'User'
local Member = require 'Member'
local Guild = require 'Guild'
local Channel = require 'Channel'

--// Types
type Data = {[string]: any}

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
    respond: (content: any) -> (boolean, string?),
    reply: (content: any) -> (boolean, string?)
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
    .respond (content: {} | string) -> (success: Boolean, error: string?) -- Send a message in the current channel
    .reply (content: {} | string) -> (success: Boolean, error: string?) -- Send a message replying to the message returned by messageCreate event

]=]

--// This
return Lumi.container('Message', function(self, data, client, serializer): Message
    --// Public
    self.ID = data.id
    self.everyone = data.mention_everyone
    self.content = data.content

    self.channel = serializer.syncs.get('Channel').get(data.channel_id) or nil
    self.author = serializer.data(data.author, User)
    self.guild = data.guild_id and serializer.syncs.get('Guild').get(data.guild_id) or nil
    self.member = serializer.data(data.member, Member) or nil

    --// Methods
    function self.respond(content: any)
        return client.sendMessage(self.channelID, content)
    end

    function self.reply(content: any)
        return client.sendMessage(self.channelID, {
            content = content,
            message_reference = {message_id = self.ID}
        })
    end

    return self
end)