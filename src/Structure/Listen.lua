--!strict
--// Requires
local Component = require '../Component'

--// Types
export type Listener = {
    listen: (eventName: string | number, callback: (...any) -> ()) -> (),
    emit: (eventName: string | number, arguments: any?) -> (),
}

--[=[

    @class Listener
    @private

    Page destined to people that want to help and extend Lumi.

    :::caution Sensitive
    Data inside components are sensitive and could break Lumi if changed.  
    Do not change or create components without reading the docs information.
    :::

    ### Usage Example:
    
    A event listener class. It has generic use so feel free to use it without many Lumi restrictions.

    ```lua
    local Connection;

    local function callback()
        print('Thanks!')
        Connection()
    end

    Connection = listener.listen('welcome', callback)

    listener.emit('Welcome')
    --> Output: Thanks!

    ```

]=]

--// This
return Component.wrap('Listener', function(self): Listener

    --// Private
    local Listening = {}

    --// Methods

    --[=[

        @within Listener

        @return function -- This function disconnects the listener when called.
        Listen to a event and when it is emitted, calls a callback.

    ]=]

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

    --[=[

        @within Listener

        Calls every callback that is listening to a given event.

    ]=]

    function self.emit(eventName: string | number, ...: any)
        local listeners = Listening[eventName]
        
        if not listeners then
            return
        end

        for _, listener in ipairs(listeners) do
            listener(...)
        end
    end

    return self.query()
end)