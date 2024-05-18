--!strict
--// Requires
local Lumi = require '../../Lumi'
local Listen = require '../Listen'
local Websocket = require 'Websocket'
local Serializer = require '../Serializer'

local Constants = require '../../Constants'
local Codes = Constants.gatewayCodes

local net = require '@lune/net' 
local task = require '@lune/task'

--// Types
type httpSocket = net.WebSocket

type Listener = Listen.Listener
type Socket = Websocket.Socket

type Payload = Serializer.Payload
type Serializer = Serializer.Serializer

export type Gateway = {
    socket: (host: string, path: string) -> (),
    reconnect: () -> (),
    resume: () -> (),
}

--// This
return Lumi.component('Gateway', function(self, token: string, client: Listener, serializer: Serializer): Gateway
    --// Private
    local heartbeatInterval
    local SESSION = {}
    local eventSequence

    local urlHost
    local urlPath
    
    local Heartbeating
    local Socket: Socket
    local CodeHandler = Listen()

    local function sendHeartBeat()
        print('Heartbeat sent')
        Socket.send(1, eventSequence)
    end

    local function heartBeat()
        print('Starting to heartbeat')
        while task.wait(heartbeatInterval) do
            sendHeartBeat()
        end
    end

    local function setupHeartBeat(package: Payload)
        print('Setting up everything')
        heartbeatInterval = package.d.heartbeat_interval * 10^-3 * .75
        if not Heartbeating then
            Heartbeating = task.spawn(heartBeat)
        end
    end

    local function handleDispatch(package: Payload)
        print('Dispatch: ' .. package.t)
        if package.t == 'READY' then
            SESSION = {ID = package.d.session_id, URL = package.d.resume_gateway_url}
        end
        eventSequence = package.s
    
        local event, data = serializer.payload(package)
        if event and data then
            client.emit(event, data)
        end
    end

    local function tryResume(closeCode: number?)
        print('Trying to resume:' .. tostring(closeCode))
        local canResume = Constants.CLOSE_CODES[closeCode]
        if canResume == (nil or true) then
            self.resume()
        else
            table.clear(SESSION)
            self.socket(urlHost, urlPath)
        end
    end

    local function initCodeHandler()
        print('Initing handlers')
        CodeHandler.listen(Codes.hello, setupHeartBeat)
        CodeHandler.listen(Codes.reconnect, tryResume)
        CodeHandler.listen(Codes.dispatch, handleDispatch)
        CodeHandler.listen(Codes.heartbeat, sendHeartBeat)
    end
    
    local function handshake()
        print('Handshake!')
        Socket.send(2, Constants.defaultIdentify(token))
    end

    local function socket()
        print('Opening socket!')
        Socket = Websocket(SESSION.URL or urlHost, urlPath, CodeHandler)
        Socket.open()
        handshake()
    end

    --// Public
    function self.socket(host: string, path: string)
        urlHost = host; urlPath = path
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
        Socket.send(6, {token = token, session_id = SESSION.ID, seq = eventSequence})
    end

    return self
end)