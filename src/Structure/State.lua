--!strict
--// Requires
local Component = require '../Component'

local Cache = require 'Cache'

local Guild = require 'Serialized/Guild'
local User = require 'Serialized/User'
local Channel = require 'Serialized/Channel'
local Role = require 'Serialized/Role'

--// Types
type Cache<asyncs> = Cache.Cache<asyncs>

type Data = Component.Data

type Guild = Guild.Guild
type User = User.User
type Channel = Channel.Channel
type Role = Role.Role

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
        local Cache = Asyncs.find(data.prototype)

        if not Cache then
            return
        end

        Asyncs.get(data.prototype).set(data.ID, data)
    end

    --[=[

        @within State
        @param ID string -- The ID of the data to be removed.
        @param container string -- The container type of the data.

        Removes data from the appropriate cache based on its container type.

    ]=]
    
    function self.removeData(ID: string, container: string)
        if not Asyncs.find(container) then
            return
        end

        Asyncs.get(container).remove(ID)
    end

    --// Getters

    --- @within Session
    function self.getGuild(ID: string): Guild
        return Asyncs.get('Guild').get(ID)
    end

    --- @within Session
    function self.getUser(ID: string): User
        return Asyncs.get('User').get(ID)
    end

    --- @within Session
    function self.getChannel(ID: string): Channel
        return Asyncs.get('Channel').get(ID)
    end

    --- @within Session
    function self.getRole(ID: string): Role
        return Asyncs.get('Role').get(ID)
    end

    return self.query()
end)
