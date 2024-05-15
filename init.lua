return {
    component = require 'src/Component',
    client = require 'src/Structure/Client',
    
    constants = function()
        return require 'src/Constants'
    end,

    events = function()
        return require 'src/Events'
    end
}