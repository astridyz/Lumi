--!strict
local Class = {}

function Class.new(): Class
    local self = {}

    function self.extends(subClass : SubClassConstructor)
        local classObject = subClass.wrap()

        for index, value in pairs(classObject) do
            if type(value) ~= 'function' then
                continue
            end

            self[index] = value
        end

        return self :: Class & {[any] : any}
    end

    --// Metatables

    local meta = {}
    meta.__metatable = 'locked'

    return setmetatable(self, meta)
end

export type ClassPrototype = {
    extends : (subClass : SubClassConstructor) -> Class & {[any] : any}
}

export type ClassConstructor = typeof(setmetatable(
    {} :: { new : () -> Class },
    {} :: {
        __metatable : string,
        __call : (any) -> Class
    }
))

export type Class = typeof(setmetatable({} :: ClassPrototype, {} :: {
    __metatable : string,
}))

export type SubClassConstructor = { wrap : (any) -> Class & {[any] : any}}

return setmetatable(Class, {__call = function(_ : any) return Class.new() end, __metatable = 'locked'}) :: ClassConstructor