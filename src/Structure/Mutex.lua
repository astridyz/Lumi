--!strict
--// Requires
local Component = require '../Component'
local task = require '@lune/task'

--// Types
export type Mutex = {
    lock: () -> (),
    unlock: () -> (),
    unlockAfter: (number) -> ()
}

--// This
return Component.wrap('Mutex', function(self): Mutex
    --// Private
    local Queue = {}
    local Active = false
    local Timeout;

    --// Public
    function self.lock()
        if not Active then
            Active = true
            return
        end

        table.insert(Queue, coroutine.running())
        coroutine.yield()
    end

    function self.unlock()
        task.wait(Timeout or 0)

        if Queue[1] then
            local waiting = Queue[1]
            coroutine.resume(waiting)

            table.remove(Queue, 1)
            table.sort(Queue, function(a, b) return a < b end)
            return
        end

        Active = false
        Timeout = 0
    end

    function self.unlockAfter(seconds: number)
        Timeout = seconds
        self.unlock()
    end


    return self.query()
end)
