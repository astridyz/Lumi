--!strict
--// Requires
local Component = require '../../Component'
local Enums = require '../../Enums'

local Option = require 'Option'

--// Types
type Data = Component.Data

type Option = Option.Option
type OptionBuilder = Option.OptionBuilder

type ApplicationCommandType = Enums.ApplicationCommandType
type InteractionContextType = Enums.InteractionContextType

type SlashParam = {
    name: string,
    description: string,
    type: ApplicationCommandType
}

export type CommandBuilt = {
    name: string?,
    description: string,
    type: ApplicationCommandType,
    options: {Option},
    nsfw: boolean,
    contexts: {InteractionContextType}
}

export type CommandBuilder = {
    setName: (name: string) -> (),
    setDescription: (description: string) -> (),
    setType: (type: ApplicationCommandType) -> (),
    addOption: (option: OptionBuilder) -> (),
    enableNSFW: () -> (),
    setContexts: (contexts: {InteractionContextType}) -> (),
    get: () -> CommandBuilt
}

--// This
return Component.wrap('CommandBuilder', function(self, data: SlashParam?): CommandBuilder
    --// Public
    local slash = {}

    if data then
        slash.name = data.name
        slash.description = data.description
        slash.type = data.type
    end

    slash.options = {}

    --// Methods
    function self.setName(name: string)
        slash.name = name
    end

    function self.setDescription(description: string)
        slash.description = description
    end
    
    function self.setType(type: ApplicationCommandType)
        slash.type = type
    end

    function self.addOption(option: OptionBuilder)
        assert(slash.type == 1, 'Options are only available for commands of type CHAT_INPUT')

        local adding = option.get()

        table.insert(slash.options, adding)
    end

    function self.enableNSFW()
        slash.nsfw = true
    end

    function self.setContexts(contexts: {InteractionContextType})
        slash.contexts = contexts
    end

    function self.get()
        return slash
    end

    return self.query()
end)