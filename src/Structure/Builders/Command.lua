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

--[=[

    @interface Command
    @within CommandBuilder
    .name string
    .description string
    .type ApplicationCommandType
    .options {Option}
    .nsfw boolean
    contexts: {InteractionContextType}

]=]

export type CommandBuilt = {
    name: string,
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

--[=[

    @class CommandBuilder

    A builder class for creating application commands.

    :::info
    This class is used to construct application commands for a Discord bot.
    :::

]=]

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

    --[=[

        @within CommandBuilder

        Sets the name of the command.

        @return CommandBuilder -- Returns the builder object for chaining methods.

    ]=]

    function self.setName(name: string)
        slash.name = name

        return self
    end

    --[=[

        @within CommandBuilder

        Sets the description of the command.

        @return CommandBuilder

    ]=]

    function self.setDescription(description: string)
        slash.description = description

        return self
    end
    
    --[=[

        @within CommandBuilder
        @param type ApplicationCommandType -- The type of the command. Available in Lumi.Enums

        Sets the type of the command.

        @return CommandBuilder

    ]=]

    function self.setType(type: ApplicationCommandType)
        slash.type = type

        return self
    end

    --[=[

        @within CommandBuilder

        Adds an option to the command.

        @return CommandBuilder

    ]=]

    function self.addOption(option: OptionBuilder)
        assert(slash.type == 1 or slash.type == nil, 'Options are only available for commands of type CHAT_INPUT')

        local data = option.get()
        table.insert(slash.options, data)

        return self
    end

    --[=[

        @within CommandBuilder

        Marks the command as NSFW.

        @return CommandBuilder

    ]=]

    function self.enableNSFW()
        slash.nsfw = true

        return self
    end

    --[=[

        @within CommandBuilder
        @param contexts {InteractionContextType}

        Sets the contexts for the command.

        @return CommandBuilder

    ]=]

    function self.setContexts(contexts: {InteractionContextType})
        slash.contexts = contexts

        return self
    end

    --[=[

        @within CommandBuilder

        Retrieves the constructed command.

        :::caution
        No need to do this manually. Lumi handles already handles it.
        :::

        @return Command -- The constructed command.

    ]=]

    function self.get()
        return slash
    end

    return self.query()
end)
