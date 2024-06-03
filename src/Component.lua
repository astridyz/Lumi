--!strict
--// This
local Component = {}

--// Types
export type Data = {[string]: any}

export type Prototype = {
    prototype: string,
    isA: (model: string) -> boolean 
}

export type Query<Plugins> = {query: () -> Plugins}

--// Functions
function Component.wrap<Plugins, Args...>(name: string, wrapper: (self: Query<Plugins> & Prototype & Plugins, Args...) -> Plugins): (Args...) -> Plugins
    return function(...: Args...)
        local self = {}

        --// Public
        self.prototype = name

        function self.isA(model: string)
            if model == self.prototype then
                return true
            end

            return false
        end

        function self.query()
            table.freeze(self)
            return self
        end
    
        return wrapper(self :: any, ...)
    end
end

return Component