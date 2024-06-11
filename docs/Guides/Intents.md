---
sidebar_position: 2
---

# Intents

Setting up your intents is an important thing to do in your bot, as it will assign which events your bot will receive.

### What is an intent?

Maintaining a stateful application can be difficult when it comes to the amount of data your app is expected to process over a Gateway connection, especially at scale.  
Gateway intents are a system to help you lower the computational burden.

#### Two types of intents exist:

- Standard intents can be passed by default. You don't need any additional permissions or configurations.

- Privileged intents require you to toggle the intent for your app in your app's settings within the Developer Portal before passing said intent.  
For verified apps (required for apps in 100+ guilds), the intent must also be approved after the verification process to use the intent.

:::info 
The information above was taken directly from the Discord documentation. [Check the complete details there.](https://discord.com/developers/docs/topics/gateway#gateway-intents)
:::

### Changing intents in Lumi

Changing intents in Lumi is as easy as printing "Hello World". Follow:
```lua
--// Getting the session component
local Session = Lumi.session()

--// Enum is a module containing important flags in Discord API
--// We will be using it to get the bitwise values of the intents
local Enum = Lumi.enums

--// Identify is a table with the field "intents"
--// this value is passed directly to the handshake,
--// so make sure you change it before connecting to the gateway.
Session.identify.intents = {
    --// We send it as a table of intents,
    --// and then Lumi converts it to a bigger number.
    Enum.gatewayIntents.guilds,
    Enum.gatewayIntents.messageContent
}

Session.connect()
```

:::tip
You can check for a full example there: https://github.com/astridyz/Lumi/blob/main/examples/intents.lua
:::

### Wait, bitwise values?

The intent number `47047`, for example, represents a combination of multiple Discord Gateway intents, allowing your bot to listen to various events.

Intents are specified using bitwise flags, where each intent corresponds to a specific bit in a 32-bit integer.  
By summing the binary values of required intents, you get a single integer representing all of them.