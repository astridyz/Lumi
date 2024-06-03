--// Requires
local Component = require '../../Component'

local User = require 'User'

--// This
return Component.wrap('Specifics', function(self, data, client, serializer): any

    --//Public
    self.guild = data.guild_id and client.state.getGuild(data.guild_id)
    self.user = data.user and serializer.data(data.user, User)

    --// Role delete case
    if data.role_id then
        self.ID = data.role_id
        
        self.guild.roles.remove(data.role_id)
        client.state.removeData(self.ID, 'Role')

        return self
    end

    --// Guild delete case
    if data.unavailable then
        self.ID = data.id

        client.state.removeData(self.ID, 'Guild')

        return self
    end

    --// Channel delete case
    if data.type then
        self.ID = data.id

        client.state.removeData(self.ID, 'Channel')
        self.guild.channels.remove(self.ID)

        return self
    end

    return self.query()
end)