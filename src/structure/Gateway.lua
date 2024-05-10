--// Requires

local Class = require '../Class'
local net = require '@lune/net' :: any
local task = require '@lune/task' :: any

--// This

local Gateway = {}

function Gateway.wrap(host : GatewayLink, path : GatewayLink): Gateway
    local self = Class()

    --// Private

    local GATEWAY_HOST = host
    local GATEWAY_PATH = path
    
    local HEARTBEAT_INTERVAL;
    --// local LAST_SEQUENCE TODO: Receive gateway events

    local Socket = net.socket(GATEWAY_HOST .. GATEWAY_PATH)

    local function process()
        while task.wait(HEARTBEAT_INTERVAL) do
            -- self:send(1, LAST_SEQUENCE or nil)
        end
    end

    --// Public

    function self:send(opcode : number, data: {})
        return Socket.send(
            net.jsonEncode {op = opcode, d = data }
        )
    end

    function self:keep()
        local helloOpcode = net.jsonDecode(Socket.next())

        HEARTBEAT_INTERVAL = helloOpcode.d.heartbeat_interval * 10^-3 * .75
        task.spawn(process)
    end

    return self
end

export type GatewayLink = string

export type Gateway =  {
    send : () -> (),
    keep: () -> ()
}

export type Websocket = Class & {
    send : () -> (),
    next : () -> (),
    close : () -> ()
}

type Class = Class.Class

return Gateway