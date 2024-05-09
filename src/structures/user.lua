local Class = require('../class.lua')

local User = {}

function User.wrap(): Class
    local self = Class()

    return self
end

type User = Class & {
}

type Class = Class.Class

return User :: Class.SubClassConstructor