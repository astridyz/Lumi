--!strict
--// Requires
local Lumi = require '../Lumi'
local task = require '@lune/task'

--// Types
export type Mutex = {
    lock: () -> (),
    unlock: () -> (),
    unlockAfter: (number) -> ()
}

--// This
return Lumi.component('Mutex', function(self): Mutex
    --// Private
    local Queue = {}
    local Active = false
    local Timeout;

    --// Public
    function self.lock()
        local this = coroutine.running()

        if not Active then
            Active = true
            return
        end

        table.insert(Queue, this)
        coroutine.yield()
    end

    function self.unlock()
        if #Queue > 0 then
            task.wait(Timeout or 0)

            local waiting = Queue[1]
            coroutine.resume(waiting)

            table.remove(Queue, 1)
            table.sort(Queue, function(a, b) return a < b end)
        else
            Active = false
        end
    end

    function self.unlockAfter(seconds: number)
        Timeout = seconds
        self.unlock()
    end


    return self
end)
