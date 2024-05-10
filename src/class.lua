local Class = {}

function Class.new(): Class
    local self = {} --// Public items

    function self:extends(subClass : SubClassConstructor)
        local meta = getmetatable(self)
        local classObject = subClass.wrap()

        meta.__index = classObject
        meta.__metatable = 'locked'

        return self
    end

    --// Metatables

    local meta = {}

    function meta:__tostring()
        return 'Class ' .. self.class
    end

    return setmetatable(self, meta)
end

export type ClassPrototype = {
    extends : (SubClass : Class) -> Class
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