--!strict
--// Requires
local Lumi = require '../../Lumi'
local User = require 'User'
local Member = require 'Member'
local Guild = require 'Guild'

--// Types
type Data = {[string]: any}

type User = User.User
type Member = Member.Member
type Guild = Guild.Guild

export type Message = {
    author: User?,
    member: Member?,
    guild: Guild?,
    prototype: string,
    ID: string,
    everyone: boolean,
    channelID: string,
    content: string,
    respond: (content: string) -> (Data?, string),
    reply: (content: string) -> (Data?, string)
}

--// This
return Lumi.container('Message', function(self, data, client, serializer): Message
    --// Public
    self.ID = data.id
    self.everyone = data.mention_everyone
    self.channelID = data.channel_id
    self.content = data.content

    self.author = not data.webhook_id and serializer.data(data.author, User) or nil
    self.guild = data.guild_id and serializer.syncs.get('Guild').get(data.guild_id) or nil
    self.member = data.member and serializer.data(data.member, Member) or nil

    function self.respond(content: string)
        return client.sendMessage(self.channelID, content)
    end

    function self.reply(content: string)
        return client.sendMessage(self.channelID, {
            content = content,
            message_reference = {message_id = self.ID}
        })
    end

    return self
end)