--!strict
--// Requires
local Lumi = require '../../Lumi'
local Listen = require '../Listen'
local Websocket = require 'Websocket'
local Serializer = require '../Serializer'
local Mutex = require '../Mutex'

local Constants = require '../../Constants'
local Codes = Constants.gatewayCodes

local net = require '@lune/net' 
local task = require '@lune/task'

--// Types
type httpSocket = net.WebSocket

type Listener = Listen.Listener
type Socket = Websocket.Socket
type Mutex = Mutex.Mutex

type Payload = Serializer.Payload
type Serializer = Serializer.Serializer

export type Gateway = {
    socket: (shardID: number, totalShard: number, host: string) -> (),
    reconnect: () -> (),
    resume: () -> (),
}

--// This
return Lumi.component('Gateway', function(self, token: string, EventHandler: Listener, serializer: Serializer, mutex: Mutex): Gateway
    --// Private
    local heartbeatInterval
    local session = {}
    local eventSequence
    local ID
    local totalShards

    local urlHost
    local urlPath = Constants.gatewayPath
    
    local Heartbeating
    local Socket: Socket
    local CodeHandler = Listen()

    local function sendHeartBeat()
        Socket.send(1, eventSequence)
    end

    local function heartBeat()
        while task.wait(heartbeatInterval) do
            sendHeartBeat()
        end
    end

    local function setupHeartBeat(package: Payload)
        heartbeatInterval = package.d.heartbeat_interval * 10^-3 * .75
        if not Heartbeating then
            Heartbeating = task.spawn(heartBeat)
        end
    end

    local function handleDispatch(package: Payload)
        if package.t == 'READY' then
            session = {ID = package.d.session_id, URL = package.d.resume_gateway_url}
        end

        eventSequence = package.s

        local event, data = serializer.payload(package)
        EventHandler.emit(event, data)
    end

    local function tryResume(closeCode: number?)
        local canResume = Constants.closeCodes[closeCode]
        if canResume or canResume == nil then
            self.resume()
        else
            table.clear(session)
            self.socket(ID, totalShards, urlHost)
        end
    end

    local function initCodeHandler()
        CodeHandler.listen(Codes.hello, setupHeartBeat)
        CodeHandler.listen(Codes.reconnect, tryResume)
        CodeHandler.listen(Codes.dispatch, handleDispatch)
        CodeHandler.listen(Codes.heartbeat, sendHeartBeat)
    end
    
    local function handshake()
        local Identify = Constants.defaultIdentify(token)
        Identify.shard = {ID, totalShards}

        Socket.send(2, Identify)
    end

    local function socket()
        Socket = Websocket(session.URL or urlHost, urlPath, CodeHandler, mutex)
        Socket.open()
        handshake()
    end

    --// Public
    function self.socket(shardID: number, totalShardCount: number, host: string)
        urlHost = host
        ID = shardID
        totalShards = totalShardCount
        
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
        Socket.send(6, {token = token, session_id = session.ID, seq = eventSequence})
    end

    return self
end)