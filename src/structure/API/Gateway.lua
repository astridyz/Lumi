--// Requires

local Class = require '../../Class'
local net = require '@lune/net' 
local task = require '@lune/task'
local Constants = require '../../Constants'

--// This

local Gateway = {}

function Gateway.wrap(host : GatewayLink, path : GatewayLink): Gateway
    local self = Class()

    --// Private

    local GATEWAY_HOST = host
    local GATEWAY_PATH = path

    local HEARTBEAT_INTERVAL;
    local SEQUENCE = "null"

    local Socket;
    local IS_SOCKET_ACTIVE = false

    local function startHeartBeatInterval()
        --// Starting heartbeat
        task.wait(0.1)
        self:send(1, SEQUENCE)

        --// Hearbeat loop
        while task.wait(HEARTBEAT_INTERVAL) do
            self:send(1, SEQUENCE)
        end
    end

    local function decode(rawPayload : Json) --// TODO: IMPROVE THIS BAGGAGE :c
        local package = net.jsonDecode(rawPayload)

        if package.op == 10 then
            HEARTBEAT_INTERVAL = package.d.heartbeat_interval * 10^-3 * .75
            task.spawn(startHeartBeatInterval)
        end

        if package.op == 11 then
            print('Event received, opcode: 11')
        end

        if package.op == 1 then
            print('Event received, opcode: 1')
            self:send(1, SEQUENCE)
        end

        if package.op == 0 then
            if package.s ~= nil then
                print('Updating sequence to: ' .. package.s)
                SEQUENCE = package.s
            end
        end
    end

    local function process()
        --// Loop
        while IS_SOCKET_ACTIVE do

            if Socket.closeCode then
                IS_SOCKET_ACTIVE = false
                error('Socket closed, closeCode: ' .. Socket.closeCode)
                return
            end
                
            local success, rawPayload = pcall(Socket.next)
            
            if not success or not rawPayload then
                IS_SOCKET_ACTIVE = false
                error('Socket closed, closeCode: ' .. Socket.closeCode)
            end

            decode(rawPayload)
        end
    end

    --// Public

    function self:send(opcode : number, data : any)
        assert(Socket ~= nil, 'Attempt to send data without a valid socket')
        return Socket.send(
            net.jsonEncode {op = opcode, d = data }
        )
    end

    function self:keep()
        local success, webSocket = pcall(net.socket, GATEWAY_HOST .. GATEWAY_PATH)
        assert(success, 'Could not create websocket')

        Socket = webSocket
        IS_SOCKET_ACTIVE = true
        task.spawn(process)
    end

    function self:handshake(token : Token)
        self:send(2, Constants.defaultIdentify(token))
    end

    return self
end

export type GatewayLink = string

export type Gateway =  Class & {
    send : (opcode : number, data : any) -> (),
    keep : () -> (),
    identify : (token : string) -> ()
}

export type Json = string

type Token = string
type WebSocket = net.WebSocket
type Class = Class.Class

return Gateway