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
}

export type OptionBuilder = {
    setName: (name: string) -> (),
    setDescription: (description: string) -> (),
    setType: (type: ApplicationCommandOptionType) -> (),
    setRequired: () -> (),
    setStringLength: (min: number, max: number?) -> (),
    setNumberLength: (min: number, max: number?) -> (),
    get: () -> Option
}

--// This
return Component.wrap('OptionBuilder', function(self, data: OptionParams?)
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
    end

    function self.setDescription(description: string)
        option.description = description
    end
    
    function self.setType(type: ApplicationCommandOptionType)
        option.type = type
    end

    function self.setRequired()
        option.required = true
    end

    function self.setStringLength(min: number, max: number?)
        assert(option.type == 3, 'String length field only available to option of type string')

        option.min_length = min
        option.max_length = max
    end

    function self.setNumberLength(min: number, max: number?)
        assert(option.type == 4 or option.type == 10, 'Number length field only available to option of type number or integer')

        option.min_value = min
        option.max_value = max
    end
    
    function self.get()
        return option
    end
    
    return self.query()
end)

