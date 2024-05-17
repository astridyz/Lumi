--!strict
--// Requires
local User = require 'User'

--// This
local Message = {}

function Message.wrap(data, serializer): Message
    local self = {} :: Message

    --// Public
    self.prototype = 'Message'
    self.ID = data.id
    self.everyone = data.mention_everyone
    self.channelID = data.channel_id
    self.author = serializer.data(data.author, User)

    function self.content()
        assert(data.content, 'MESSAGE_CONTENT intent not enabled')
        return data.content
    end

    return self
end

export type Message = {
    author: User,
    prototype: string,
    ID: string,
    everyone: boolean,
    channelID: string,
    content: () -> string | false
}

type User = User.User

return Message
