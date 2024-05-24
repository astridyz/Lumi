---
sidebar_position: 1
---

# Listening once to an event

Given the following code we will be doing our additions:

```lua
local function onMessageCreate(message)
    print(message.content)
end

Session.listen(Events.messageCreate, onMessageCreate)

Session.connect()
```

### `Session.listen()` return

The method `.listen()` returns a function that when called, disconnects our listener from the callback.

:::info
More information about the `.listen()` method is [available at its API page](/api/Session#listen)
:::

Then, you can store this function in a variable and call it after the first callback call. Follow:

```lua
--// Initializating an empty variable to give access to the "onMessageCreate" function
local Connection;

local function onMessageCreate(message)
    print(message.content)

    --// Calling it after the first callback call.
    --// This will disconnect the listener and stop listening to the event.
    Connection()
end

--// Changing the variable value to the .listen() method
Connection = Session.listen(Events.messageCreate, onMessageCreate)

Session.connect()
```