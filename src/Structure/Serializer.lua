--!strict
--// Requires
local Lumi = require '../Lumi'
local Constants = require '../Constants'
local Cache = require 'Cache'

--// Types
type Data = {[string]: any}
type Cache<asyncs> = Cache.Cache<asyncs>

export type Serializer = {
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

--// This
return Lumi.component('Serializer', function(self, client: any, containers: {Cache<any>}): Serializer
    --// Public
    self.syncs = Cache('Serialized', 'k', Cache)

    for _, cache in ipairs(containers) do
        self.syncs.set(cache.name, cache)
    end

    local function InsertInCache(data)
        local cache = self.syncs.get(data.container)
        if cache then
            cache.set(data.ID, data)
        end
    end

    --// Methods
    function self.payload(package)
        local container = Constants.payloads[package.t]
        if not container then
            return
        end
        
        local data = container(package.d, client, self)
        assert(data.container)
        InsertInCache(data)
    
        return package.t, table.freeze(data)
    end

    function self.data(rawData, container)
        local data = container(rawData)
        assert(data.container)
        InsertInCache(data)

        return data
    end

    return self
end)