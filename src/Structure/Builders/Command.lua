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
    setName: (name: string) -> CommandBuilder,
    setDescription: (description: string) -> CommandBuilder,
    setType: (type: ApplicationCommandType) -> CommandBuilder,
    addOption: (option: OptionBuilder) -> CommandBuilder,
    enableNSFW: () -> CommandBuilder,
    setContexts: (contexts: {InteractionContextType}) -> CommandBuilder,
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

        return self
    end

    function self.setDescription(description: string)
        slash.description = description

        return self
    end
    
    function self.setType(type: ApplicationCommandType)
        slash.type = type

        return self
    end

    function self.addOption(option: OptionBuilder)
        assert(slash.type == 1 or slash.type == nil, 'Options are only available for commands of type CHAT_INPUT')

        local data = option.get()
        table.insert(slash.options, data)

        return self
    end

    function self.enableNSFW()
        slash.nsfw = true

        return self
    end

    function self.setContexts(contexts: {InteractionContextType})
        slash.contexts = contexts

        return self
    end

    function self.get()
        return slash
    end

    return self.query()
end)