--// Requires

local Class = require '../../Class'
local net = require '@lune/net' 
local task = require '@lune/task'
local Constants = require '../../Constants'
local Listen = require '../Listen'

--// This

local Gateway = {}

function Gateway.wrap(host : GatewayLink, path : GatewayLink): Gateway
    local self = Class().extends(Listen) :: Gateway

    --// Private

    local GATEWAY_HOST = host
    local GATEWAY_PATH = path

    local HEARTBEAT_INTERVAL;
    local SEQUENCE = "null"
    local IS_SOCKET_ACTIVE = false

    local Socket;

    local function startHeartBeatInterval()
        --// Starting heartbeat
        task.wait(0.1)
        self.send(1, SEQUENCE)

        --// Hearbeat loop
        while task.wait(HEARTBEAT_INTERVAL) do
            self.send(1, SEQUENCE)
        end
    end

    local function setupHeartBeat(package : Payload)
        HEARTBEAT_INTERVAL = package.d.heartbeat_interval
        task.spawn(startHeartBeatInterval)
    end

    local function decode(rawPayload : Json) --// TODO: IMPROVE THIS BAGGAGE :c
        local package : Payload = net.jsonDecode(rawPayload)
        self.emit(package.op, package)
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

    function self.send(opcode : number, data : any)
        assert(Socket ~= nil, 'Attempt to send data without a valid socket')
        return Socket.send(
            net.jsonEncode {op = opcode, d = data }
        )
    end

    function self.keep()
        local success, webSocket = pcall(net.socket, GATEWAY_HOST .. GATEWAY_PATH)
        assert(success, 'Could not create websocket')

        Socket = webSocket
        IS_SOCKET_ACTIVE = true
        task.spawn(process)
    end

    function self.handshake(token : Token)
        self.send(2, Constants.defaultIdentify(token))
    end

    function self.initListeners(clientListener : Listener)
        local Codes = Constants.gatewayCodes

        self.listen(Codes.HEARTBEAT, setupHeartBeat)
        
        self.listen(Codes.DISPATH, function(package : Payload)
            SEQUENCE = package.s
            print(package)
        end)

        self.listen(Codes.HEARTBEAT, function()
            self:send(1, SEQUENCE)
        end)
    end

    return self
end

export type Payload = {
    op : number,
    d : {[any] : any},
    s : number,
    t : string
}

export type GatewayLink = string

export type Gateway =  Class & Listener & {
    send : (opcode : number, data : any) -> (),
    keep : () -> (),
    identify : (token : string) -> (),
    initListeners : (client : Listener) -> ()
}

export type Json = string

type Token = string
type WebSocket = net.WebSocket

type Class = Class.Class
type Listener = Listen.Listener

return Gateway