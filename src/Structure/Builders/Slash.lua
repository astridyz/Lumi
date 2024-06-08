--!strict
--// Requires
local Component = require '../../Component'
local Enums = require '../../Enums'

local Option = require 'Option'

--// Types
type Data = Component.Data

type Option = Option.OptionBuilt

type SlashParam = {
    name: string,
    description: string,
    type: ApplicationCommandType
}

type ApplicationCommandType = Enums.ApplicationCommandType
type InteractionContextType = Enums.InteractionContextType

type SlashBuilt = {
    name: string,
    description: string,
    type: ApplicationCommandType,
    options: {Option},
    nsfw: boolean,
    contexts: {InteractionContextType}
}

export type slashCommandBuilder = typeof(setmetatable({} :: {
    setName: (name: string) -> (),
    setDescription: (description: string) -> (),
    setType: (type: ApplicationCommandType) -> (),
    addOption: (option: Option) -> (),
    enableNSFW: () -> (),
    setContexts: (contexts: {InteractionContextType}) -> (),
}, {} :: {
    __call: () -> SlashBuilt
}))

--// This
return Component.wrap('SlashCommand', function(self, data: SlashParam?): slashCommandBuilder
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

    function self.addOption(option: Option)
        assert(slash.type == 1, 'Options are only available for commands of type CHAT_INPUT')

        table.insert(slash.options, option)
    end

    function self.enableNSFW()
        slash.nsfw = true
    end

    function self.setContexts(contexts: {InteractionContextType})
        slash.contexts = contexts
    end

    --// Meta
    local meta = {}
    
    function meta:__call()
        return slash
    end

    setmetatable(self, meta)

    return self.query()
end)