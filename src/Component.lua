--!strict
--> This
local Component = {}
local Meta = {}

--> Meta
function Meta:__call(_ : any): Instance
    return self.new()
end

--> Functions
function Component.new(): Instance
    local self = {}

    --> Public
    function self.extends(subClass: Factory)
        local classObject = subClass.wrap()

        for index, value in pairs(classObject) do
            if type(value) ~= 'function' then
                continue
            end

            self[index] = value
        end

        return self :: Instance & {[any]: any}
    end

    --> Metatables
    local meta = {}
    meta.__metatable = 'locked'

    return setmetatable(self, meta)
end

type Manager = typeof(setmetatable(
    {} :: { new: () -> Instance},
    {} :: {
        __metatable: string,
        __call: (any) -> Instance
    }
))

export type Instance = typeof(setmetatable(
    {} :: {
        extends: (subClass: Factory) -> Instance & {[any]: any}
    },
    {} :: {
        __metatable : string
    }
))
export type Factory = {wrap: (any) -> Instance & {[any]: any}}

return setmetatable(table.clone(Component), Meta) :: Manager