--!strict
--// Requires
local Component = require '../../Component'
local net = require '@lune/net' 
local task = require '@lune/task'
local Constants = require '../../Constants'
local Listen = require '../Listen'
local Websocket = require 'Websocket'
local Serializer = require '../Serializer'

--// This
local Gateway = {}

function Gateway.wrap(host: string, path: string, Token: string, client: Listener, Serializer: Serializer)
    local self = Component() :: Gateway

    --// Private
    local HEARTBEAT_INTERVAL
    local SESSION
    local SEQUENCE

    local Heartbeating
    local Socket: Socket
    local Listener = Listen.wrap()

    local function heartBeat()
        while task.wait(HEARTBEAT_INTERVAL) do
            Socket.send(1, SEQUENCE)
        end
    end

    local function setupHeartBeat(package: Payload)
        HEARTBEAT_INTERVAL = package.d.heartbeat_interval * 10^-3 * .75
        if not Heartbeating then
            Heartbeating = task.spawn(heartBeat)
        end
    end

    local function handleDispath(package: Payload)
        if package.t == 'READY' then
            SESSION = {ID = package.d.session_id, URL = package.d.resume_gateway_url}
        end
        SEQUENCE = package.s
    
        local event, data = Serializer.data(package)
        if event and data then
            client.emit(event, data)
        end
    end

    local function tryResume(closeCode: number?)
        local canResume = Constants.CLOSE_CODES[closeCode]
        if canResume then
            self.resume()
        elseif canResume == false then
            self.socket()
        else
            self.resume()
        end
    end

    local function initListeners()
        local Codes = Constants.GATEWAY_CODES
        Listener.listen(Codes.HELLO, setupHeartBeat)
        Listener.listen(Codes.RECONNECT, tryResume)
        Listener.listen(Codes.DISPATH, handleDispath)
        Listener.listen(Codes.HEARTBEAT, function() Socket.send(1, SEQUENCE); return; end)
    end
    
    local function handshake()
        Socket.send(2, Constants.defaultIdentify(Token))
    end

    --// Public
    function self.socket()
        initListeners()
        Socket = Websocket.wrap(host, path, Listener)
        Socket.open()
        handshake()
    end

    function self.reconnect()
        Socket.close()
        Socket = Websocket.wrap(host, path, Listener)
        Socket.open()
        handshake()
    end

    function self.resume()
        Socket.close()
        Socket = Websocket.wrap(SESSION.URL, path, Listener)
        Socket.open()
        Socket.send(6, {token = Token, session_id = SESSION.ID, seq = SEQUENCE})
    end

    return self.socket()
end

export type Gateway = Instance & {
    socket: () -> (),
    reconnect: () -> (),
    resume: () -> (),
}

type httpSocket = net.WebSocket

type Instance = Component.Instance
type Listener = Listen.Listener

type Socket = Websocket.Socket
type Payload = Serializer.Payload
type Serializer = Serializer.Serializer

return Gateway