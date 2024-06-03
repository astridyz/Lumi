--!strict
--// Requires
local Component = require '../Component'

--// Types
type mode = ('k' | 'v' | 'kv')

export type Cache<model> = {
    name: string,
    iter: () -> Asyncs,
    get: (key: any) -> model,
    find: (key: any) -> boolean,
    remove: (key: any) -> (),
    set: (key: any, value: any) -> (),
    protect: (key: any) -> ()
}

export type Asyncs = typeof(setmetatable({} :: { [any]: any }, {} :: { __mode: mode? }))

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
return Component.wrap('Cache', function<model>(self, name: string, mode: mode?, factory: (...any) -> model): Cache<model>
    --// Private
    local asyncs = setmetatable({}, {__mode = mode})
    local protected = {}

    --// Public

    --[=[

        @within Cache
        @prop name string
        
    ]=]

    self.name = name

    --[=[
        
        @within Cache

        To iterate under all asyncs in a for loop.

        @return {model}

    ]=]

    function self.iter()
        return asyncs
    end

    --- @within Cache
    function self.get(key: any): model
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
    function self.remove(key: any)
        if self.find(key) then
            self.set(key, nil)
        end
    end

    --- @within Cache
    function self.protect(key: any)
        local value = asyncs[key]
        protected[key] = value
        asyncs[key] = nil
    end

    return self.query()
end)