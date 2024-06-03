--// Requires
local Component = require '../../Component'

--// Types
type Data = Component.Data

export type Application = {
    ID: string,
    name: string,
    description: string,
    isPublic: boolean
}

--[=[

    @class Application

    Represents a Discord application with various properties.

]=]

--// This
return Component.wrap('Application', function(self, data): Application

    --[=[

        @within Application
        @prop ID string

        The unique identifier for the application.

    ]=]

    self.ID = data.id

    --[=[

        @within Application
        @prop name string

        The name of the application.

    ]=]

    self.name = data.name

    --[=[

        @within Application
        @prop description string

        The description of the application.

    ]=]

    self.description = data.description

    --[=[

        @within Application
        @prop isPublic boolean

        Indicates if the application is public.
        
    ]=]
    
    self.isPublic = data.bot_public

    return self.query()
end)
