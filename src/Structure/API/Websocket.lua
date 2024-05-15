--!strict
--// Requires
local Component = require '../../Component'
local net = require '@lune/net'
local task = require '@lune/task'
local Listen = require '../Listen'

--// This
local Websocket = {}

function Websocket.wrap(host: string, path: string, listener: Listener): Socket
    local self = Component() :: Socket

    --// Private
    local httpSocket
    local IS_SOCKET_ACTIVE
    local Processing
    
    local function decode(package: string)
        local payload = net.jsonDecode(package)
        listener.emit(payload.op, payload)
    end

    local function process()
        while IS_SOCKET_ACTIVE and task.wait() do

            if httpSocket.closeCode then
                IS_SOCKET_ACTIVE = false
                listener.emit(7, httpSocket.closeCode)
                return
            end
                
            local success, package = pcall(httpSocket.next)
            
            if not success or not package then
                IS_SOCKET_ACTIVE = false
                listener.emit(7, httpSocket.closeCode)
                return
            end

            decode(package)
        end
    end

    --// Public
    function self.send(opcode: number, data: any)
        assert(httpSocket, 'Attempt to send payload without a valid socket')
        httpSocket.send(
            net.jsonEncode {op = opcode, d = data}
        )
    end

    function self.open()
        assert(not IS_SOCKET_ACTIVE, 'Attempt to open the same socket two times')

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

export type Socket = Instance & {
    send: (opcode: number, payload: any) -> (),
    open: () -> (),
    close: () -> ()
}

type Instance = Component.Instance
type Websocket = net.WebSocket
type Listener = Listen.Listener

return Websocket