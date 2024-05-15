--!strict
--> This
local Message = {}

function Message.wrap(data): Message
    local self = {}

    --> Public
    self.id = data.id
    self.everyone = data.mention_everyone
    self.channelID = data.channel_id

    function self.content()
        assert(data.content, 'MESSAGE_CONTENT intent not enabled')
        return data.content
    end

    function self.webhook()
        return data.webhook_id or false
    end

    return self
end

export type Message = {
    id: string,
    everyone: boolean,
    channelID: string,
    webhook: () -> (),
    content: () -> string | false
}

return Message