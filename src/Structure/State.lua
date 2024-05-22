--// Requires
local Lumi = require '../Lumi'

local Cache = require 'Cache'

local Guild = require 'Serialized/Guild'
local User = require 'Serialized/User'
local Channel = require 'Serialized/Channel'

--// Types
type Cache<asyncs> = Cache.Cache<asyncs>

type Data = Lumi.Data

type Guild = Guild.Guild
type User = User.User
type Channel = Channel.Channel

export type State = {
    addData: (data: Data) -> (),
    getGuild: (ID: string) -> Guild,
    getUser: (ID: string) -> User,
    getChannel: (ID: string) -> Channel,
}

--// This
return Lumi.component('State', function(self): State
    --// Private
    local Asyncs = Cache('State', 'k', Cache)

    --// Caches
    Asyncs.set('Guild', Cache('Guild', 'k', Guild))
    Asyncs.set('User', Cache('User', 'k', User))
    Asyncs.set('Channel', Cache('Channel', 'k', Channel))

    --// Methods
    function self.addData(data: Data)
        local Cache = Asyncs.find(data.container)

        if not Cache then
            return
        end

        Asyncs.get(data.container).set(data.ID, data)
    end

    --// Getters
    function self.getGuild(ID: string): Guild
        return Asyncs.get('Guild').get(ID)
    end

    function self.getUser(ID: string): User
        return Asyncs.get('User').get(ID)
    end

    function self.getChannel(ID: string): Channel
        return Asyncs.get('Channel').get(ID)
    end

    return self
end)