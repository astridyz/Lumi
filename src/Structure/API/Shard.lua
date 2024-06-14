--!strict
--// Requires
local Component = require '../../Component'
local Constants = require '../../Constants'

local task = require '@lune/task'

local urlPath = Constants.gatewayPath
local closeCodes = Constants.closeCodes
local closeErrors = Constants.closeErrors

local net = require '@lune/net'
type httpSocket = net.WebSocket

local Listen = require '../Listen'
type Listener = Listen.Listener

local Websocket = require 'Socket'
type Socket = Websocket.Socket

local Serializer = require '../Serializer'
type Payload = Serializer.Payload
type Serializer = Serializer.Serializer

local Mutex = require '../Mutex'
type Mutex = Mutex.Mutex

--// Types
export type Identify = {
    intents: {number},
    presence: {
        status: string,
        afk: boolean
    }
}

export type Gateway = {
    bind: (shardID: number, totalShard: number, host: string, identify: Identify) -> (),
    reconnect: () -> (),
    resume: () -> (),
    handshake: () -> (),
    waitForHandshake: () -> ()
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
return Component.wrap('Gateway', function(self, token: string, eventHandler: Listener, serializer: Serializer, mutex: Mutex): Gateway
    --// Private
    local heartbeatInterval
    local session = {}
    local eventSequence
    local ID
    local totalShards
    local Identify

    local urlHost
    local performedHandshake
    
    local Heartbeating
    local Socket

    local CodeHandler = Listen()

    local handlers = {}

    function handlers.heartbeatAck()
        Socket.send(1, eventSequence)
    end

    local function heartBeat()
        while task.wait(heartbeatInterval) do
            handlers.heartbeatAck()
        end
    end

    function handlers.hello(package: Payload)
        heartbeatInterval = package.d.heartbeat_interval * 10^-3 * .75

        if Heartbeating then
            return
        end

        Heartbeating = task.spawn(heartBeat)
    end

    function handlers.dispatch(package: Payload)
        if package.t == 'READY' then
            session = {ID = package.d.session_id, URL = package.d.resume_gateway_url}
        end

        eventSequence = package.s

        local event, data = serializer.payload(package)
        eventHandler.emit(event, data)
    end

    function handlers.reconnect(closeCode: number?)
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

        error('Error: ' .. closeErrors[closeCode] .. ' closing bot!', 2)
    end

    function handlers.unexpectedOpcode(package: Payload)
        error('Unexpected opcode: ' .. Constants.gatewayDescription[package.op])
    end

    local function initCodeHandler()
        for _, code in pairs(Constants.gatewayCodes) do

            local handler = handlers[Constants.gatewayDescription[code]]

            if not handler then
                CodeHandler.listen(code, handlers.unexpectedOpcode)
            end

            CodeHandler.listen(code, handler)
        end
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
            for _, intent in ipairs(Identify.intents) do
                intents = intents + intent
            end
        end

        payload.presence = Identify.presence or payload.presence
        payload.intents = intents
        
        Socket.send(2, payload)
        performedHandshake = true
    end

    --[=[
    
        @within Gateway

        Yilding function to lock current coroutine until handshake is made.
    
    ]=]

    function self.waitForHandshake()
        repeat task.wait()
        until performedHandshake == true
    end

    return self.query()
end)
