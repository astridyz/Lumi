--!strict
--> Requires
local Component = require '../../Component'
local net = require '@lune/net' 
local task = require '@lune/task'
local Constants = require '../../Constants'
local Listen = require '../Listen'
local Websocket = require 'Websocket'
local Serializer = require '../Serializer'

--> This
local Gateway = {}

function Gateway.wrap(host: GatewayLink, path: GatewayLink, Token: string, Serializer: Serializer)
    local self = Component() :: Gateway

    --> Private
    local HEARTBEAT_INTERVAL;
    local SESSION: {URL: string, ID: string};
    local SEQUENCE: (string | number)? = "null"
    local Heartbeating: thread;

    local Socket: Socket;
    local Listener = Listen.wrap()

    local function heartBeat()
        while task.wait(HEARTBEAT_INTERVAL) do
            Socket.send(1, SEQUENCE)
        end
    end

    local function setupHeartBeat(package: Payload)
        HEARTBEAT_INTERVAL = package.d.heartbeat_interval * 10^-3 * .75
        if not Heartbeating then Heartbeating = task.spawn(heartBeat) end
    end

    local function handleDispath(rawData: Payload)
        if rawData.t == 'READY' then
            SESSION = {ID = rawData.d.session_id, URL = rawData.d.resume_gateway_url}
        end

        SEQUENCE = rawData.s;
        Serializer.data(rawData)
    end

    local function tryResume(closeCode: number?)
        print('Trying to resume: ' .. tostring(closeCode))
        if Constants.CLOSE_CODES[closeCode] then --> Resuming
            print('Resuming')
            self.resume()
        else --> Reconnecting
            print('Reconnecting')
            self.socket()
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

    --> Public
    function self.socket()
        initListeners()
        Socket = Websocket.wrap(host, path, Listener)
        Socket.open()
        
        return handshake()
    end

    function self.reconnect()
        Socket.close()
        Socket = Websocket.wrap(host, path, Listener)
        Socket.open()
        return handshake()
    end

    function self.resume()
        Socket.close()
        Socket = Websocket.wrap(SESSION.URL, path, Listener)
        Socket.open()
        Socket.send(6, {token = Token, session_id = SESSION.ID, seq = SEQUENCE})
    end

    self.socket()
    return self
end

export type Gateway = Instance & {
    socket: () -> (),
    reconnect: () -> (),
    resume: () -> (),
}

type httpSocket = net.WebSocket

type Instance = Component.Instance
type Listener = Listen.Listener
type Serializer = Serializer.Serializer

type GatewayLink = Websocket.GatewayLink

type Socket = Websocket.Socket
type Payload = Serializer.Payload

return Gateway