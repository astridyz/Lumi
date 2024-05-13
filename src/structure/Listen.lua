--!strict
--// Requires

local Class = require '../Class'

--// This

local Listen = {}

function Listen.wrap(): Listener
    local self = Class.new() :: Listener

    local Listening = {}

    function self.listen(eventName : string | number, callback : Callback)
        assert(type(eventName) == 'string' or 'number', 'Invalid event name: only strings or numbers')

        if not Listening[eventName] then
            Listening[eventName] = {}
        end

        table.insert(Listening[eventName], callback)
    end

    function self.emit(eventName : any, ... : any?)
        local listeners = Listening[eventName]
        
        if not listeners then
            return
        end

        for _, listener in ipairs(listeners) do
            listener(...)
        end
    end

    return self
end

export type Callback = (any) -> (any)

export type Listener = Class & {
    listen : (eventName : string | number, callback : Callback) -> (),
    emit : (eventName : string | number, arguments : any?) -> ()
}

type Class = Class.Class

return Listen