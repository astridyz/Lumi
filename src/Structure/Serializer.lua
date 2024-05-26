--!strict
--// Requires
local Lumi = require '../Lumi'
local Constants = require '../Constants'

local Cache = require 'Cache'
local State = require 'State'

--// Types
type Cache<asyncs> = Cache.Cache<asyncs>

type State = State.State

type Data = Lumi.Data

export type Serializer = {
    payload: (package: Payload) -> (string, {any}?),
    data: (rawData: Data?, factory: any) -> Data
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
return Lumi.component('Serializer', function(self, client: any, state: State): Serializer
    --// Methods

    --[=[

        @within Serializer
        @param package {}
        @return (eventName: string, data: {})

    ]=]

    function self.payload(package): (string, {any}?)
        local container = Constants.payloads[package.t]
        
        if not container then
            return package.t, nil
        end
        
        local data = container(package.d, client, self)
        state.addData(data)
    
        return package.t, table.freeze(data)
    end

    --[=[

        @within Serializer
        @param rawData {}
        @param factory (args...) -> model
        @return (data: container) -- Caution: this data is freezed and cannot be modified.

    ]=]

    function self.data(rawData: Data?, factory)
        if not rawData then
            return nil
        end
        
        local data = factory(rawData, client, self)
        state.addData(data)

        return table.freeze(data)
    end

    return self
end)