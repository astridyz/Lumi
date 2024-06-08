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
    function self.setName(name: string)
        option.name = name

        return self
    end

    function self.setDescription(description: string)
        option.description = description

        return self
    end
    
    function self.setType(type: ApplicationCommandOptionType)
        option.type = type

        return self
    end

    function self.setRequired()
        option.required = true

        return self
    end

    function self.setStringLength(min: number, max: number?)
        assert(option.type == 3, 'String length field only available to option of type string')

        option.min_length = min
        option.max_length = max

        return self
    end

    function self.setNumberLength(min: number, max: number?)
        assert(option.type == 4 or option.type == 10, 'Number length field only available to option of type number or integer')

        option.min_value = min
        option.max_value = max
        
        return self
    end
    
    function self.get()
        return option
    end
    
    return self.query()
end)

