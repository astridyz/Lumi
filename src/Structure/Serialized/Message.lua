--!strict
--// This
local Message = {}

function Message.wrap(data): Message
    local self = {}

    --// Public
    self.prototype = 'Message'
    self.id = data.id
    self.everyone = data.mention_everyone
    self.channelID = data.channel_id

    function self.content()
        assert(data.content, 'MESSAGE_CONTENT intent not enabled')
        return data.content
    end

    return self
end

export type Message = {
    prototype: string,
    id: string,
    everyone: boolean,
    channelID: string,
    content: () -> string | false
}

return Message
