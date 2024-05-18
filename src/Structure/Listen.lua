--!strict
--// Requires
local Lumi = require '../Lumi'

--// Types
export type Listener = {
    listen: (eventName: string | number, callback: (...any) -> ()) -> (),
    emit: (eventName: string | number, arguments: any?) -> (),
}

--// This
return Lumi.component('Listener', function(self): Listener

    --// Private
    local Listening = {}

    --// Methods
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
end)