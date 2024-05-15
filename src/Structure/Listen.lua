--!strict
--// Requires
local Component = require '../Component'

--// This
local Listen = {}

function Listen.wrap(): Listener
    local self = Component() :: Listener

    local Listening = {}

    function self.listen(eventName: string | number, callback: (...any) -> ())
        assert(type(eventName) == 'string' or 'number', 'Invalid event name: only strings or numbers')

        if not Listening[eventName] then
            Listening[eventName] = {}
        end

        table.insert(Listening[eventName], callback)

        return function()
            table.remove(Listening[eventName], table.find(Listening[eventName], callback))
        end
    end

    function self.emit(eventName: string | number, ...: any)
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
    listen: (eventName: string | number, callback: (...any) -> ()) -> (),
    emit: (eventName: string | number, arguments: any?) -> (),
}

type Instance = Component.Instance

return Listen