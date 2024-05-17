--!strict
--// Requires
local Component = require '../../Component'
local Listen = require '../Listen'
local Websocket = require 'Websocket'
local Serializer = require '../Serializer'

local Constants = require '../../Constants'
local Codes = Constants.GATEWAY_CODES

local net = require '@lune/net' 
local task = require '@lune/task'

--// This
local Gateway = {}

function Gateway.wrap(Token: string, client: Listener, serializer: Serializer): Gateway
    local self = Component() :: Gateway

    --// Private
    local HEARTBEAT_INTERVAL
    local SESSION = {}
    local SEQUENCE

    local HOST
    local PATH

    local Heartbeating
    local Socket: Socket
    local CodeHandler = Listen.wrap()

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

    local function handleDispatch(package: Payload)
        if package.t == 'READY' then
            SESSION = {ID = package.d.session_id, URL = package.d.resume_gateway_url}
        end
        SEQUENCE = package.s
    
        local event, data = serializer.payload(package)
        if event and data then
            client.emit(event, data)
        end
    end

    local function tryResume(closeCode: number?)
        local canResume = Constants.CLOSE_CODES[closeCode]
        if canResume == (nil or true) then
            self.resume()
        else
            table.clear(SESSION)
            self.socket(HOST, PATH)
        end
    end

    local function initCodeHandler()
        CodeHandler.listen(Codes.HELLO, setupHeartBeat)
        CodeHandler.listen(Codes.RECONNECT, tryResume)
        CodeHandler.listen(Codes.DISPATH, handleDispatch)
        CodeHandler.listen(Codes.HEARTBEAT, function()
            Socket.send(1, SEQUENCE)
        end)
    end
    
    local function handshake()
        Socket.send(2, Constants.defaultIdentify(Token))
    end

    local function socket()
        Socket = Websocket.wrap(SESSION.URL or HOST, PATH, CodeHandler)
        Socket.open()
        handshake()
    end

    --// Public
    function self.socket(host: string, path: string)
        HOST = host; PATH = path
        initCodeHandler()
        socket()
    end

    function self.reconnect()
        Socket.close()
        socket()
    end

    function self.resume()
        Socket.close()
        socket()
        Socket.send(6, {token = Token, session_id = SESSION.ID, seq = SEQUENCE})
    end

    return self
end

export type Gateway = Instance & {
    socket: (host: string, path: string) -> (),
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