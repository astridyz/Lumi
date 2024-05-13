--!strict
--// Requires

local Class = require '../../Class'
local net = require '@lune/net'
local task = require '@lune/task'
local Listen = require '../Listen'

--// This

local Websocket = {}

function Websocket.wrap(host : GatewayLink, path : GatewayLink, listener : Listener)
    local self = Class() :: Socket

    --// Private
    local httpSocket : Websocket;
    local IS_SOCKET_ACTIVE : boolean;
    local Processing : thread;
    local gatewayListener = listener
    
    local function decode(rawPayload : Json)
        local package : Payload = net.jsonDecode(rawPayload)
        gatewayListener.emit(package.op, package)
    end

    local function process()
        --// Loop
        while IS_SOCKET_ACTIVE and task.wait() do

            if httpSocket.closeCode then
                IS_SOCKET_ACTIVE = false
                listener.emit(7, httpSocket.closeCode)
                return
            end
                
            local success, rawPayload = pcall(httpSocket.next)
            
            if not success or not rawPayload then
                IS_SOCKET_ACTIVE = false
                listener.emit(7, httpSocket.closeCode :: number)
                return
            end

            decode(rawPayload :: Json)
        end
    end

    --// Public

    function self.send(opcode : number, data : any): true?
        assert(httpSocket, 'Attempt to send data without a valid socket')
        httpSocket.send(
            net.jsonEncode {op = opcode, d = data }
        )

        return true
    end

    function self.open()
        assert(not IS_SOCKET_ACTIVE, 'Attempt to open a socket with an active websocket')

        local success, webSocket = pcall(net.socket, host .. path)
        assert(success, 'Could not create websocket')

        httpSocket = webSocket
        IS_SOCKET_ACTIVE = true
        Processing = task.spawn(process)
    end

    function self.close()
        if not IS_SOCKET_ACTIVE then
            return
        end

        IS_SOCKET_ACTIVE = false
        task.cancel(Processing)
        httpSocket.close(1000)
    end

    return self
end

export type Payload = {
    op : number,
    d : {[any] : any},
    s : number?,
    t : string?
}

export type ResumeFunction = (closeCode : number?) -> ()

export type Socket = Class & {
    send : (opcode : number, data : any) -> true?,
    open : () -> (),
    close : () -> ()
}

export type GatewayLink = string

export type Json = string

type Class = Class.Class
type Websocket = net.WebSocket
type Listener = Listen.Listener

return Websocket