--!strict
--// Requires
local Component = require '../../Component'
local Enums = require '../../Enums'

--// Types
type Data = Component.Data

type ApplicationCommandOptionType = Enums.ApplicationCommandOptionType

type OptionParams = {
    name: string,
    description: string,
    required: boolean,
    type: ApplicationCommandOptionType
}

--[=[

    @interface Option
    @within OptionBuilder
    .name string
    .description string
    .required boolean
    .type ApplicationCommandOptionType
    .min_length number,
    .max_length number?,
    .min_value number,
    .max_value number?

]=]

export type Option = {
    name: string,
    description: string,
    required: boolean,
    type: ApplicationCommandOptionType,
    min_length: number,
    max_length: number?,
    min_value: number,
    max_value: number?
}

export type OptionBuilder = {
    setName: (name: string) -> OptionBuilder,
    setDescription: (description: string) -> OptionBuilder,
    setType: (type: ApplicationCommandOptionType) -> OptionBuilder,
    setRequired: () -> OptionBuilder,
    setStringLength: (min: number, max: number?) -> OptionBuilder,
    setNumberLength: (min: number, max: number?) -> OptionBuilder,
    get: () -> Option
}

--[=[

    @class OptionBuilder

    A builder component for creating command options.

]=]

--// This
return Component.wrap('OptionBuilder', function(self, data: OptionParams?): OptionBuilder
    --// Public
    local option = {}

    if data then
        option.name = data.name
        option.description = data.description
        option.required = data.required
        option.type = data.type
    end

    --// Methods

    --[=[

        @within OptionBuilder

        Sets the name of the option.

        @return OptionBuilder -- Returns the builder object for chaining methods
    ]=]

    function self.setName(name: string)
        option.name = name

        return self
    end

    --[=[

        @within OptionBuilder

        Sets the description of the option.

        @return OptionBuilder

    ]=]

    function self.setDescription(description: string)
        option.description = description

        return self
    end
    
    --[=[

        @within OptionBuilder
        @param type ApplicationCommandOptionType -- The type of the option. Available in Lumi.Enums

        Sets the type of the option.

        @return OptionBuilder

    ]=]

    function self.setType(type: ApplicationCommandOptionType)
        option.type = type

        return self
    end

    --[=[

        @within OptionBuilder

        Marks the option as required.

        @return OptionBuilder -- Returns the builder instance.

    ]=]

    function self.setRequired()
        option.required = true

        return self
    end

    --[=[

        @within OptionBuilder

        Sets the string length constraints for the option.

        @return OptionBuilder

    ]=]

    function self.setStringLength(min: number, max: number?)
        assert(option.type == 3, 'String length field only available to option of type string')

        option.min_length = min
        option.max_length = max

        return self
    end

    --[=[

        @within OptionBuilder

        Sets the number value constraints for the option.

        @return OptionBuilder

    ]=]

    function self.setNumberLength(min: number, max: number?)
        assert(option.type == 4 or option.type == 10, 'Number length field only available to option of type number or integer')

        option.min_value = min
        option.max_value = max
        
        return self
    end
    
    --[=[

        @within OptionBuilder

        Retrieves the constructed option.

        :::caution
        No need to do this manually. Lumi handles already handles it.
        :::

        @return Option -- The constructed option.

    ]=]

    function self.get()
        return option
    end
    
    return self.query()
end)
