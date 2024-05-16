--!strict
--// This
local Guild = {}

function Guild.wrap(data): Guild?
    local self = {}

    if data.unavailable then
        return nil
    end

    --// Public
    self.prototype = 'Guild'
    self.members = data.member_count
    self.id = data.id
    self.name = data.name
    self.description = data.description
    self.locale = data.preferred_locale

    return self
end

export type Guild = {
    prototype: string,
    members: number,
    id: number,
    name: string,
    description: string,
    locale: string
}

return Guild