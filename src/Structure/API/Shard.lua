--!strict
--// Requires
local Lumi = require '../../Lumi'
local Constants = require '../../Constants'

local urlPath = Constants.gatewayPath
local Codes = Constants.gatewayCodes
local closeCodes = Constants.closeCodes
local closeErrors = Constants.closeErrors

local net = require '@lune/net' 
local task = require '@lune/task'

local Listen = require '../Listen'
local Websocket = require 'Websocket'
local Serializer = require '../Serializer'
local Mutex = require '../Mutex'

--// Types
type httpSocket = net.WebSocket

type Listener = Listen.Listener
type Socket = Websocket.Socket
type Mutex = Mutex.Mutex

type Payload = Serializer.Payload
type Serializer = Serializer.Serializer

export type Identify = {
    intents: {number},
    presence: {
        status: string,
        afk: boolean
    }
}

export type Gateway = {
    bind: (shardID: number, totalShard: number, host: string) -> (),
    reconnect: () -> (),
    resume: () -> (),
    handshake: () -> ()
}

--[=[

    @class Gateway

    Handles the WebSocket connection and communication with Discord's Gateway.

    :::caution Sensitive
    Data inside components are sensitive and could break Lumi if changed.  
    Do not change or create components without reading the docs information.
    :::

]=]

--// This
return Lumi.component('Gateway', function(self, token: string, EventHandler: Listener, serializer: Serializer, mutex: Mutex): Gateway
    --// Private
    local heartbeatInterval
    local session = {}
    local eventSequence
    local ID
    local totalShards
    local Identify

    local urlHost
    
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
        local canResume = closeCodes[closeCode]
        
        if canResume == false or canResume == nil then
            self.resume()
            return
        end
        
        if canResume == true then
            table.clear(session)
            self.reconnect()
            return
        end

        error('Error identified: ' .. closeErrors[closeCode] .. ' cannot resume or reconnect!', 2)
    end

    local function unexpectedOpcode(package: Payload)
        error('Unexpected opcode: ' .. Constants.gatewayDescription[package.op])
    end

    local function initCodeHandler()
        CodeHandler.listen(Codes.hello, setupHeartBeat)
        CodeHandler.listen(Codes.reconnect, tryResume)
        CodeHandler.listen(Codes.dispatch, handleDispatch)
        CodeHandler.listen(Codes.heartbeat, sendHeartBeat)
        CodeHandler.listen(Codes.invalidSession, unexpectedOpcode)
    end

    local function socket()
        Socket = Websocket(session.URL or urlHost, urlPath, CodeHandler, mutex)
        Socket.open()
        self.handshake()
    end

    --// Public

    --[=[

        @within Gateway
        
        Initializes the WebSocket connection and starts handling events.

    ]=]
    
    function self.bind(shardID: number, totalShardCount: number, host: string, identify: Identify)
        urlHost = host
        ID = shardID
        totalShards = totalShardCount
        Identify = identify

        initCodeHandler()
        socket()
    end

    --[=[

        @within Gateway

        Reconnects to the WebSocket by closing the current connection 
        and opening a new one.

    ]=]

    function self.reconnect()
        Socket.close()
        socket()
    end

    --[=[

        @within Gateway

        Resumes the WebSocket connection by closing the current connection, 
        opening a new one, and sending a resume payload.

    ]=]

    function self.resume()
        Socket.close()
        socket()
        Socket.send(6, {token = token, session_id = session.ID, seq = eventSequence})
    end

    --[=[

        @within Gateway

        Performs the initial handshake with the Discord Gateway 
        by sending an identify payload.

    ]=]

    function self.handshake()
        assert(typeof(Identify) == 'table', 'Identify structure needs to be a table.')

        local payload = Constants.identifyStructure()
        payload.shard = {ID, totalShards}
        payload.token = token

        local intents = payload.intents
        
        if Identify.intents then
            for _, number in ipairs(Identify.intents) do
                intents = intents + number
            end
        end

        payload.presence = Identify.presence or payload.presence
        payload.intents = intents
        
        Socket.send(2, payload)
    end

    return self
end)
