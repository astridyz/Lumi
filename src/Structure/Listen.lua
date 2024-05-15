--!strict
--> Requires

local Component = require '../Component'

--> This

local Listen = {}

function Listen.wrap(): Listener
    local self = Component() :: Listener

    local Listening = {}

    function self.listen<args...>(eventName: string | number, callback: (args...) -> any)
        assert(type(eventName) == 'string' or 'number', 'Invalid event name: only strings or numbers')

        if not Listening[eventName] then
            Listening[eventName] = {}
        end

        table.insert(Listening[eventName], callback)
    end

    function self.emit(eventName: any, ...: any)
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

export type Listener = Instance & {
    listen: <args...>(eventName: string | number, callback: (args...) -> any) -> (),
    emit: (eventName: string | number, arguments: any?) -> ()
}

type Instance = Component.Instance

return Listen