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

--// This
return Lumi.component('Cache', function<model>(self, name: string, mode: mode?, factory: (...any) -> model): Cache<model>
    --// Private
    local asyncs = setmetatable({}, {__mode = mode})
    local protected = {}

    --// Public
    self.name = name

    function self.get(key): model
        return asyncs[key] or protected[key] or nil
    end

    function self.find(key): boolean
        return asyncs[key] and true or false
    end

    function self.set(key, value)
        asyncs[key] = value
    end

    function self.protect(key)
        local value = asyncs[key]
        protected[key] = value
        asyncs[key] = nil
    end

    return self
end)