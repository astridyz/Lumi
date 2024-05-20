"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[573],{47774:e=>{e.exports=JSON.parse('{"functions":[{"name":"login","desc":"Authenticates your token in Discord API, \\ntrying to call `Session.connect()` without a valid token \\nwill throw an error.\\n\\n    ","params":[{"name":"token","desc":"Your application token","lua_type":"string"}],"returns":[],"function_type":"static","source":{"line":87,"path":"src/Structure/Session.lua"}},{"name":"connect","desc":"Connects in Discord Gateway, opening the websocket connection.  \\nAfter calling it, your bot should go online and receive all Discord events.\\n\\n\\n    ","params":[],"returns":[{"desc":"","lua_type":"(error: string?)"}],"function_type":"static","source":{"line":110,"path":"src/Structure/Session.lua"}},{"name":"listen","desc":"Listen to a given `Event` and calls a callback when it is emitted.\\n\\n### Usage Example:\\n\\n```lua\\nSession.listen(Events.messageCreate, function(message)\\n    print(message.author.ID)\\nend)\\n```\\n\\n    ","params":[{"name":"event","desc":"A event object. All events are listed in `Events.lua` file.","lua_type":"{}"},{"name":"callback","desc":"","lua_type":"(args...) -> ()"}],"returns":[],"function_type":"static","source":{"line":144,"path":"src/Structure/Session.lua"}},{"name":"getGuild","desc":"","params":[{"name":"ID","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Guild?\\r\\n"}],"function_type":"static","source":{"line":151,"path":"src/Structure/Session.lua"}},{"name":"getUser","desc":"","params":[{"name":"ID","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"User?\\r\\n"}],"function_type":"static","source":{"line":157,"path":"src/Structure/Session.lua"}},{"name":"sendMessage","desc":"Sends a message in the given channel.  \\nThe content  table needs to be created using constructors available in Lumi.\\n\\n    ","params":[{"name":"channelID","desc":"","lua_type":"string"},{"name":"content","desc":"","lua_type":"{} | string"}],"returns":[{"desc":"","lua_type":"(success: boolean, error: string?)"}],"function_type":"static","source":{"line":171,"path":"src/Structure/Session.lua"}}],"properties":[{"name":"user","desc":"The bot user object.","lua_type":"User","source":{"line":73,"path":"src/Structure/Session.lua"}}],"types":[],"name":"Session","desc":"Main interface for interacting with Discord.\\n\\n:::info Topologically-aware\\n    All functions bellow need a valid token and a opened gateway to be used.  \\n:::","source":{"line":49,"path":"src/Structure/Session.lua"}}')}}]);