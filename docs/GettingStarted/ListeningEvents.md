---
sidebar_position: 3
---

# Listening to events

In the previous sections, you did a basic bot structure.  
In this tutorial, we will be listening to the `messageCreate` event and printing the message content.  

With the previous tutorial code, we will be adding the listener:

```lua
local Lumi = require '../libs/Lumi'

local Session = Lumi.session()

Session.login('YOUR_BOT_TOKEN')

Session.connect()
```

### The `Session.listen()` method

:::info Session methods
For detailed information about the `.listen()` method, [you can check its API page](/api/Session#listen)
:::

`.listen()` is a wrapper method. It calls another method from the component [Listener](/api/Listener) and starts listening to a given event.
Lets start modifying our code:

```lua
local Lumi = require '../libs/Lumi'

--// Our event module. It was mentioned in the previous tutorial
--// It holds all events available in Lumi. Also necessary to type-check.
local Events = Lumi.events

local Session = Lumi.session()

Session.login('YOUR_BOT_TOKEN')

--// Defining our handler function, it will be called when the given event is emitted
--// Automatic type cast on "message"
local function onMessageCreate(message)
    --// Printing the field content from the message
    --// Note that you need the message_content intent to
    --// have access to messages content (check the tip bellow)
    print(message.content)
end

--// Selecting the event
--// Passing our "onMessageCreate" function as a callback.
Session.listen(Events.messageCreate, onMessageCreate)

Session.connect()
```

:::tip Messages content
Tried and it printed a empty string? Your [MESSAGE_CONTENT privileged intent](https://discord.com/developers/docs/topics/gateway#privileged-intents) may be disabled.  
But don't worry, you can enable it easily, [check this guide.](/docs/Guides/Intents)

:::

In the next page, you will be doing your first requests to Discord.