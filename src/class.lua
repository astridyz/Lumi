local Class = {}

function Class.new(): Class
    local self = {} --// Public items

    function self.extends(subClass : SubClassConstructor)
        local classObject = subClass.wrap()

        for index, value in pairs(classObject) do
            if type(value) ~= 'function' then
                continue
            end

            self[index] = value
        end

        return self
    end

    --// Metatables

    local meta = {}

    function meta.__tostring()
        return 'Class ' .. self.class
    end

    meta.__metatable = 'locked'

    return setmetatable(self, meta)
end

export type ClassPrototype = {
    extends : (subClass : SubClassConstructor) -> {}
}

export type ClassConstructor = typeof(setmetatable(
    {} :: { new : () -> Class },
    {} :: {
        __metatable : string,
        __call : (any) -> Class
    }
))

export type Class = typeof(setmetatable({} :: ClassPrototype, {} :: {
    __tostring : () -> string,
    __metatable : string,
}))

export type SubClassConstructor = { wrap : (any) -> Class}

return setmetatable(Class, {__call = function(_) return Class.new() end, __metatable = 'locked'}) :: ClassConstructor