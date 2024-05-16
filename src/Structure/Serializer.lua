--!strict
--// Requires
local Constants = require '../Constants'
local Component = require '../Component'
local Cache = require 'Cache'

--// This
local Serializer = {}

function Serializer.wrap(...: Cache<any>): Serializer
    local self = Component() :: Serializer

    --// Public
    self.syncs = Cache.wrap('Client', 'k', Cache)

    for _, cache in ipairs {...} do
        self.syncs.set(cache.name, cache)
    end

    function self.data(package: Payload): (string?, {any}?)
        local container = Constants.payloads[package.t]
        if not container then
            return
        end
        
        local data = container.wrap(package.d)

        local cache = self.syncs.get(data.prototype)
        if cache then
            cache.set(data.id, data)
        end

        return package.t, table.freeze(data)
    end

    return self
end

export type Serializer = Instance & {
    syncs: Cache<Cache<any>>,
    data: (package: Payload) -> (string?, {any}?)
}

export type Payload = {
    op: number,
    d: {[any]: any},
    s: number,
    t: string
}

type Cache<prototype> = Cache.Cache<prototype>

type Instance = Component.Instance

return Serializer