--!strict
--// Requires

local Class = require '../../Class'
local net = require '@lune/net' 
local task = require '@lune/task'
local Constants = require '../../Constants'
local Listen = require '../Listen'
local Websocket = require 'Websocket'

--// This

local Gateway = {}

function Gateway.wrap(host : GatewayLink, path : GatewayLink, Token : Token)
    local self = Class() :: Gateway

    --// Private
    local HEARTBEAT_INTERVAL;
    local SESSION : {URL : string, ID : string};
    local SEQUENCE : (string | number)? = "null"
    local Heartbeating : thread;

    local Socket : Socket;
    local Listener = Listen.wrap()

    local function heartBeat()
        while task.wait(HEARTBEAT_INTERVAL) do
            Socket.send(1, SEQUENCE)
        end
    end

    local function setupHeartBeat(package : Payload)
        HEARTBEAT_INTERVAL = package.d.heartbeat_interval * 10^-3 * .75
        Heartbeating = task.spawn(heartBeat)
    end

    local function tryResume(closeCode : number?)
        if Constants.closeCodes[closeCode] then --// Resuming
            self.resume()
        else --// Reconnecting
            self.socket()
        end
    end

    local function handleEvents(package : Payload)
        if package.t == 'READY' then
            SESSION = {
                ID = package.d.session_id,
                URL = package.d.resume_gateway_url
        }
        end

        SEQUENCE = package.s;
    end

    local function initListeners()
        local Codes = Constants.gatewayCodes
        Listener.listen(Codes.HELLO, setupHeartBeat)

        Listener.listen(Codes.RECONNECT, tryResume)
        
        Listener.listen(Codes.DISPATH, handleEvents)

        Listener.listen(Codes.HEARTBEAT, function() Socket.send(1, SEQUENCE); return; end)
    end
    
    local function handshake(): true?
        return Socket.send(2, Constants.defaultIdentify(Token))
    end

    --// Public
    function self.socket()
        if Heartbeating then
            task.cancel(Heartbeating)
        end

        if Socket then
            Socket.close()
        else
            initListeners()
        end

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

    return self.socket()
end

export type Gateway =  Class & {
    socket : () -> (),
    resume : (closeCode : number?) -> (),
}

type Token = string
type httpSocket = net.WebSocket

type Class = Class.Class
type Listener = Listen.Listener

type GatewayLink = Websocket.GatewayLink

type Socket = Websocket.Socket
type ResumeFunction = Websocket.ResumeFunction
type Json = Websocket.Json
type Payload = Websocket.Payload

return Gateway