--!strict
--// Requires

local Class = require '../../Class'
local net = require '@lune/net' 
local task = require '@lune/task'
local Constants = require '../../Constants'
local Listen = require '../Listen'

--// This

local Gateway = {}

function Gateway.wrap(host : GatewayLink, path : GatewayLink, tryResume : resumeFunction, Token : Token): Gateway
    local self = Class().extends(Listen) :: Gateway

    --// Private

    local HEARTBEAT_INTERVAL;
    local SESSION : {URL : string, ID : string};
    local SEQUENCE : string? | number? = "null"
    local IS_SOCKET_ACTIVE = false
    local Socket : WebSocket;

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
        HEARTBEAT_INTERVAL = package.d.heartbeat_interval * 10^-3 * .75
        task.spawn(startHeartBeatInterval)
    end

    local function decode(rawPayload : Json)
        local package : Payload = net.jsonDecode(rawPayload)
        self.emit(package.op, package)
    end

    local function initListeners()
        local Codes = Constants.gatewayCodes

        self.listen(Codes.HELLO, setupHeartBeat)
        
        self.listen(Codes.DISPATH, function(package : Payload)
            
            if package.t == 'READY' then
                SESSION = {
                    ID = package.d.session_id,
                    URL = package.d.resume_gateway_url
            }
            end

            SEQUENCE = package.s
            return
        end)

        self.listen(Codes.RECONNECT, function()
            tryResume(0)
            return
        end)

        self.listen(Codes.HEARTBEAT, function()
            self.send(1, SEQUENCE)
            return
        end)
    end

    local function process()
        --// Loop
        while IS_SOCKET_ACTIVE do

            if Socket.closeCode then
                IS_SOCKET_ACTIVE = false
                tryResume(Socket.closeCode)
                return
            end
                
            local success, rawPayload = pcall(Socket.next)
            
            if not success or not rawPayload then
                IS_SOCKET_ACTIVE = false
                tryResume(Socket.closeCode)
                return
            end

            decode(rawPayload :: Json)
        end
    end
    
    local function handshake()
        self.send(2, Constants.defaultIdentify(Token))
    end

    --// Public
    function self.send(opcode : number, data : any)
        assert(Socket ~= nil, 'Attempt to send data without a valid socket')
        return Socket.send(
            net.jsonEncode {op = opcode, d = data }
        )
    end

    function self.open()
        local success, webSocket = pcall(net.socket, host .. path)
        assert(success, 'Could not create websocket')

        Socket = webSocket
        IS_SOCKET_ACTIVE = true

        initListeners()
        task.spawn(process)
        handshake()
    end

    function self.close()
        if IS_SOCKET_ACTIVE then
            Socket.close(1000)
        end
    end

    function self.resume()
        assert(not IS_SOCKET_ACTIVE, 'Attempt to resume an active socket')

        local success, webSocket = pcall(net.socket, SESSION.URL .. path)
        assert(success, 'Could not create websocket')

        Socket = webSocket
        IS_SOCKET_ACTIVE = true

        self.send(6, {token = Token, session_id = SESSION.ID, seq = SEQUENCE})
    end

    return self
end

export type Payload = {
    op : number,
    d : {[any] : any},
    s : number?,
    t : string?
}

export type resumeFunction = (closeCode : number?) -> ()

export type GatewayLink = string

export type Gateway =  Class & Listener & {
    open : () -> (),
    resume : () -> (),
    close : () -> (),
    send : (opcode : number, data : any) -> (),
    handshake : () -> ()
}

export type Json = string

type Token = string
type WebSocket = net.WebSocket

type Class = Class.Class
type Listener = Listen.Listener

return Gateway