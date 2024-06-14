--!strict
--// Packages
local Constants = require '../../Constants'
local task = require '@lune/task'

local gatewayDelay = Constants.defaultGatewayDelay

local Component = require '../../Component'
type Data = Component.Data

local net = require '@lune/net'
type Websocket = net.WebSocket

local Listen = require '../Listen'
type Listener = Listen.Listener

local Mutex = require '../Mutex'
type Mutex = Mutex.Mutex

--// Types
export type Socket = {
    send: (opcode: number, payload: any) -> (),
    open: () -> (),
    close: () -> ()
}

--[=[

    @class Websocket

    Manages the WebSocket connection to Discord's Gateway, handling the sending 
    and receiving of messages.

    :::caution Sensitive
    Data inside components are sensitive and could break Lumi if changed.  
    Do not change or create components without reading the docs information.
    :::

]=]

--// This
return Component.wrap('Websocket', function(self, host: string, path: string, codeHandler: Listener, mutex: Mutex): Socket
    --// Private
    local httpSocket
    local IS_SOCKET_ACTIVE
    local Processing
    
    local function decode(package: string)
        local payload = net.jsonDecode(package)
        codeHandler.emit(payload.op, payload)
    end

    local function process()
        while IS_SOCKET_ACTIVE and task.wait() do
            if httpSocket.closeCode then
                IS_SOCKET_ACTIVE = false
                codeHandler.emit(7, httpSocket.closeCode)
                return
            end
                
            local success, package = pcall(httpSocket.next)
            
            if not success or not package then
                IS_SOCKET_ACTIVE = false
                codeHandler.emit(7, httpSocket.closeCode)
                return
            end

            decode(package)
        end
    end

    --// Public

    --[=[

        @within Websocket
        @param opcode number -- The opcode of the message.
        @param data any -- The payload of the message.

        Sends a message through the WebSocket.

    ]=]

    function self.send(opcode: number, data: any)
        assert(httpSocket, 'Attempt to send payload without a valid socket')
        
        mutex.lock()
        httpSocket.send(net.jsonEncode {op = opcode, d = data})
        mutex.unlockAfter(gatewayDelay)
    end

    --[=[

        @within Websocket

        Opens the WebSocket connection and starts processing incoming messages.

    ]=]

    function self.open()
        assert(not IS_SOCKET_ACTIVE, 'Attempt to open the same socket two times')

        local success, webSocket = pcall(net.socket, host .. path)
        assert(success, 'Could not create websocket')

        httpSocket = webSocket
        IS_SOCKET_ACTIVE = true
        Processing = task.spawn(process)
    end

    --[=[

        @within Websocket

        Closes the WebSocket connection.

    ]=]
    
    function self.close()
        if not IS_SOCKET_ACTIVE then
            return
        end

        IS_SOCKET_ACTIVE = false
        task.cancel(Processing)
        httpSocket.close(1000)
    end

    return self.query()
end)
