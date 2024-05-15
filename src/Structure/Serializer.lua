--!strict
--// Requires
local Component = require '../Component'
local Listen = require 'Listen'
local Constants = require '../Constants'

--// This
local Serializer = {}

function Serializer.wrap(): Serializer
    local self = Component().extends(Listen) :: Serializer

    --// Public
    function self.data(rawData: Payload)
        local container = Constants.PAYLOADS[rawData.t]
        if not container then
            return
        end
        
        local data = container.wrap(rawData.d)
        self.emit(rawData.t, table.freeze(data))
    end

    return self
end

export type Payload = {
    op: number,
    d: {[any]: any},
    s: number,
    t: string
}

export type Serializer = Instance & Listener & {
    data: (rawData: Payload) -> ()
}

type Instance = Component.Instance
type Listener = Listen.Listener

return Serializer