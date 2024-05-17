--// Requires
local Component = require '../Component'

--// This
local Cache = {}

function Cache.wrap<prototype>(name: string, mode: mode?, factory: {wrap: (...any) -> prototype}): Cache<prototype>
    local self = Component() :: Cache<prototype>

    --// Private
    local asyncs = setmetatable({}, {__mode = mode})
    local protected = {}

    --// Public
    self.name = name

    function self.get(key: any): prototype
        return asyncs[key] or protected[key] or nil
    end

    function self.find(key: any): boolean
        return asyncs[key] and true or false
    end

    function self.set(key: any, value: any)
        asyncs[key] = value
    end

    function self.protect(key: any)
        local value = asyncs[key]
        protected[key] = value
        asyncs[key] = nil
    end

    return self
end

type mode = ('k' | 'v' | 'kv')

export type Cache<asyncs> = Instance & {
    name: string,
    get: (key: any) -> asyncs,
    find: (key: any) -> boolean,
    set: (key: any, value: any) -> ()
}

type Instance = Component.Instance

return Cache