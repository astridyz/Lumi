--!strict
--// Requires
local Constants = require '../Constants'
local Component = require '../Component'
local Cache = require 'Cache'

--// This
local Serializer = {}

function Serializer.wrap(client, ...: Cache<any>): Serializer
    local self = Component() :: Serializer

    --// Private
    local function InsertInCache(data)
        local cache = self.syncs.get(data.prototype)
        if cache then
            cache.set(data.ID, data)
        end
    end

    --// Public
    self.syncs = Cache.wrap('Client', 'k', Cache)

    for _, cache in ipairs {...} do
        self.syncs.set(cache.name, cache)
    end

    function self.payload(package: Payload): (string?, {any}?)
        local container = Constants.payloads[package.t]
        if not container then
            return
        end
        
        local data = container.wrap(package.d, client, self)

        assert(data.prototype)
        InsertInCache(data)
    
        return package.t, table.freeze(data)
    end

    function self.data(rawData: Data, container: any): Data
        local data = container.wrap(rawData)

        assert(data.prototype)
        InsertInCache(data)

        return data
    end

    return self
end

export type Serializer = Instance & {
    syncs: Cache<Cache<any>>,
    payload: (package: Payload) -> (string?, {any}?),
    data: (rawData: Data, factory: any) -> Data
}

export type Payload = {
    op: number,
    d: Data,
    s: number,
    t: string
}

type Data = {[string]: any}

type Cache<prototype> = Cache.Cache<prototype>

type Instance = Component.Instance

return Serializer