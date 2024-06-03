--!strict
--// Requires
local Component = require '../../Component'

--// Types
export type User = {
    ID: string,
    username: string,
    discriminator: string,
    nickname: string,
    isBot: boolean,
    mention: () -> string
}

--[=[
    
    @class User

    Represents a user with properties for ID, username, discriminator, nickname, bot status, and mention functionality.

]=]

--// This
return Component.wrap('User', function(self, data): User
    --//Public

    --[=[
        
        @within User
        @prop ID string

        The unique identifier for the user.

    ]=]

    self.ID = data.id

    --[=[

        @within User
        @prop username string

        The username of the user.

    ]=]

    self.username = data.username

    --[=[

        @within User
        @prop discriminator string

        The discriminator of the user.

    ]=]

    self.discriminator = data.discriminator

    --[=[

        @within User
        @prop nickname string

        The global nickname of the user.

    ]=]

    self.nickname = data.global_name

    --[=[

        @within User
        @prop isBot boolean

        Whether the user is a bot.

    ]=]

    self.isBot = data.bot

    --[=[

        @within User
        @method mention

        Returns a mention string for the user.

        @return string

    ]=]

    function self.mention(): string
        return string.format('<@%s>', self.ID)
    end

    return self.query()
end)
