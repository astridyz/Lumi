--!strict
--// Packages
local Component = require '../Component'
type Data = Component.Data

local Cache = require 'Cache'
type Cache<asyncs> = Cache.Cache<asyncs>

local Guild = require 'Serialized/Guild'
type Guild = Guild.Guild

local User = require 'Serialized/User'
type User = User.User

local Channel = require 'Serialized/Channel'
type Channel = Channel.Channel

local Role = require 'Serialized/Role'
type Role = Role.Role

--// Types
export type State = {
    addData: (data: any) -> (),
    removeData: (ID: string, container: string) -> (),
    getGuild: (ID: string) -> Guild,
    getUser: (ID: string) -> User,
    getChannel: (ID: string) -> Channel,
    getRole: (ID: string) -> Role,
}

--[=[

    @class State

    Main interface for managing state and caching data for Discord entities.

]=]

--// This
return Component.wrap('State', function(self): State
    --// Private
    local Asyncs = Cache('State', 'k', Cache)

    --// Caches
    Asyncs.set('Guild', Cache('Guild', 'k', Guild))
    Asyncs.set('User', Cache('User', 'k', User))
    Asyncs.set('Channel', Cache('Channel', 'k', Channel))
    Asyncs.set('Role', Cache('Role', 'k', Role))

    --// Methods

    --[=[

        @within State
        @param data Data -- The data object to be added to the cache.

        Adds data to the appropriate cache based on its container type.

    ]=]

    function self.addData(data: any)
        if not Asyncs.find(data.prototype) then
            return
        end

        Asyncs.get(data.prototype).set(data.ID, data)
    end

    --[=[

        @within State
        @param ID string
        @param container string

        Removes data from the appropriate cache based on its container type.

    ]=]
    
    function self.removeData(ID: string, container: string)
        if not Asyncs.find(container) then
            return
        end

        Asyncs.get(container).remove(ID)
    end

    --// Getters

    --- @within State
    function self.getGuild(ID: string): Guild
        return Asyncs.get('Guild').get(ID)
    end

    --- @within State
    function self.getUser(ID: string): User
        return Asyncs.get('User').get(ID)
    end

    --- @within State
    function self.getChannel(ID: string): Channel
        return Asyncs.get('Channel').get(ID)
    end

    --- @within State
    function self.getRole(ID: string): Role
        return Asyncs.get('Role').get(ID)
    end

    return self.query()
end)
