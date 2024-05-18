--!strict
--// This
local Lumi = {}

--// Functions
function Lumi.component<Plugins, Args...>(name: string, wrapper: (self: Prototype & Plugins, Args...) -> Plugins): (Args...) -> Plugins
    return function(...: Args...)
        local meta = { __metatable = 'locked' }
        local self = setmetatable({}, meta)
            
        --// Public
        self.model = name
    
        return wrapper(self :: any, ...)
    end
end

function Lumi.container<Fields>(name: string, wrapper: (self: Container & Fields, Data, ...any) -> Fields): (data: Data, client: any, serializer: any) -> Fields?
    return function(data: Data, client: any, serializer: any)
        local self = {}
        
        --// Public
        self.container = name
    
        return wrapper(self :: any, data, client, serializer) or nil
    end
end

export type Data = {[string]: any}

export type Container = {
    container: string
}

export type Prototype = typeof(setmetatable(
    {} :: {
        prototype: string
    },
    {} :: {
        __metatable: string
    }
))

return Lumi