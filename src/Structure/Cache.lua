--!strict
--// Requires
local Lumi = require '../Lumi'

--// Types
type mode = ('k' | 'v' | 'kv')

export type Cache<asyncs> = {
    name: string,
    get: (key: any) -> asyncs,
    find: (key: any) -> boolean,
    set: (key: any, value: any) -> (),
    protect: (key: any) -> ()
}

--[=[

    @class Cache
    @private

    Page destined to people that want to help and extend Lumi.

    :::caution Sensitive
        Data inside components are sensitive and could break Lumi if changed.  
        Do not change or create components without reading the docs information.
    :::

    Cache is a specific usage component to store serialized data or models.

]=]

--// This
return Lumi.component('Cache', function<model>(self, name: string, mode: mode?, factory: (...any) -> model | {model}): Cache<model>
    --// Private
    local asyncs = setmetatable({}, {__mode = mode})
    local protected = {}

    --// Public

    --[=[

        @within Cache
        @prop name string
        
    ]=]

    self.name = name

    --- @within Cache
    function self.get(key: any): model?
        return asyncs[key] or protected[key] or nil
    end

    --- @within Cache
    function self.find(key: any): boolean
        return asyncs[key] and true or false
    end

    --- @within Cache
    function self.set(key: any, value: any)
        asyncs[key] = value
    end

    --- @within Cache
    function self.protect(key: any)
        local value = asyncs[key]
        protected[key] = value
        asyncs[key] = nil
    end

    return self
end)