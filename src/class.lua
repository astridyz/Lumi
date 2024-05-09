local Class = {}

function Class.wrap(): Class
    local self = {} --// Public items

    function self:publicMethod()
        print('Yeay')
    end

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
    publicMethod : () -> (),
    extends : (Class) -> Class
}

export type ClassConstructor = typeof(setmetatable(
    {} :: { wrap : () -> Class },
    {} :: {
        __metatable : string,
        __call : (any) -> Class
    }
))

export type Class = typeof(setmetatable({} :: ClassPrototype, {} :: {
    __tostring : () -> string,
    __metatable : string,
}))

export type SubClassConstructor = { wrap : () -> Class}

return setmetatable(Class, {__call = function(_) return Class.wrap() end, __metatable = 'locked'}) :: ClassConstructor