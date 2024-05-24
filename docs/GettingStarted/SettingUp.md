---
sidebar_position: 2
---

# Starting a new project

:::info
This page assumes that you have read and completed the steps available at [Installation.](/docs/Installation.md)
:::

After following the installation page, your repository should be like this:
```
libs/
  Lumi/
src/
  bot.lua
```

### Getting your bot online

Lumi package has 3 importants modules inside it: Manager, Session and Events.
The main interface for interacting with Discord is the Session module, it is your client. You can check more about it [on its API page.](/api/Session)

Now, lets open a connection to Discord and make your bot go online. On your `main.lua` put this code:

```lua
--// Require Lumi
local Lumi = require '../libs/Lumi'

--// Session is a factory function that returns our Session component.
local Session = Lumi.session()

--// Authenticate your token in the Discord API
Session.login('YOUR_BOT_TOKEN')

--// Open gateway connection, your bot should go online now
Session.connect()
```

In the next page, you will learn how to listen and get information on events.