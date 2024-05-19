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

--[=[

    @class Serializer
    @private

    Page destined to people that want to help and extend Lumi.

    :::caution Sensitive
        Data inside components are sensitive and could break Lumi if changed.  
        Do not change or create components without reading the docs information.
    :::

    A specific usage class used to desserialize Discord objects 
    and serialize it to an readable table

]=]

--// This
return Lumi.component('Serializer', function(self, client: any, containers: {Cache<any>}): Serializer
    --// Public

    --[=[

        @within Serializer
        @prop syncs Cache<Cache>
        Yes, a cache of caches.

    ]=]

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

    --[=[

        @within Serializer
        @param package {}
        @return (eventName: string, data: {})

    ]=]

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

    --[=[

        @within Serializer
        @param rawData {}
        @param factory (args...) -> model
        @return (data: container) -- Caution: this data is freezed and cannot be modified.

    ]=]

    function self.data(rawData, factory)
        if not rawData then
            return nil
        end
        local data = factory(rawData)
        assert(data.container)
        InsertInCache(data)

        return table.freeze(data)
    end

    return self
end)