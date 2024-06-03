--!strict
--// Requires
local Component = require '../../Component'

local User = require 'User'
local Member = require 'Member'
local Guild = require 'Guild'
local Channel = require 'Channel'

--// Types
type Data = Component.Data

type User = User.User
type Member = Member.Member
type Guild = Guild.Guild
type Channel = Channel.Channel

export type Message = {
    author: User?,
    member: Member?,
    guild: Guild?,
    ID: string,
    everyone: boolean,
    channel: Channel,
    content: string,
    reply: (content: any) -> string?
}

--[=[

    @class Message

    Represents a Discord message object.

]=]

--// This
return Component.wrap('Message', function(self, data, client, serializer): Message
    --// Public

    --[=[

        @within Message
        @prop ID string

        The unique identifier for the message.

    ]=]

    self.ID = data.id

    --[=[

        @within Message
        @prop everyone boolean

        Indicates if the message mentions everyone.

    ]=]

    self.everyone = data.mention_everyone

    --[=[

        @within Message
        @prop content string

        The content of the message.

    ]=]

    self.content = data.content

    --[=[

        @within Message
        @prop channel Channel

        The channel where the message was sent.

    ]=]

    self.channel = client.state.getChannel(data.channel_id)

    --[=[

        @within Message
        @prop author User

        The author of the message.

    ]=]

    self.author = serializer.data(data.author, User)

    --[=[

        @within Message
        @prop guild Guild?

        The guild where the message was sent.

    ]=]

    self.guild = data.guild_id and client.state.getGuild(data.guild_id) or nil

    --[=[

        @within Message
        @prop member Member?

        The member who sent the message.

    ]=]

    self.member = serializer.data(data.member, Member :: any) or nil

    --[=[

        @within Message
        @param content string | {}

        Sends a reply to the message. The content can be a string or a Data object.

        @return (error: string?)

    ]=]

    function self.reply(content: string | Data)
        return client.sendMessage(self.channel.ID, content, self.ID)
    end

    return self.query()
end)
