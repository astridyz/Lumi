--!strict
--// Requires
local Lumi = require '../Lumi'

local Cache = require 'Cache'

local Guild = require 'Serialized/Guild'
local User = require 'Serialized/User'
local Channel = require 'Serialized/Channel'
local Role = require 'Serialized/Role'

--// Types
type Cache<asyncs> = Cache.Cache<asyncs>

type Data = Lumi.Data

type Guild = Guild.Guild
type User = User.User
type Channel = Channel.Channel
type Role = Role.Role

export type State = {
    addData: (data: Data) -> (),
    removeData: (ID: string, container: string) -> (),
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
    Asyncs.set('Role', Cache('Role', 'k', Role))

    --// Methods
    function self.addData(data: Data)
        local Cache = Asyncs.find(data.container)

        if not Cache then
            return
        end

        Asyncs.get(data.container).set(data.ID, data)
    end

    function self.removeData(ID: string, container: string)
        if not Asyncs.find(container) then
            return
        end

        Asyncs.get(container).remove(ID)
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

    function self.getRole(ID: string): Role
        return Asyncs.get('Role').get(ID)
    end

    return self
end)