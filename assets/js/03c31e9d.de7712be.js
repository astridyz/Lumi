"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[2573],{47774:e=>{e.exports=JSON.parse('{"functions":[{"name":"login","desc":"Authenticates your token in Discord API. \\nTrying to call `Session.connect()` without a valid token \\nwill throw an error.\\n\\n    ","params":[{"name":"token","desc":"Your application token","lua_type":"string"}],"returns":[],"function_type":"static","source":{"line":117,"path":"src/Structure/Session.lua"}},{"name":"connect","desc":"Connects to Discord Gateway, opening the websocket connection.  \\nAfter calling it, your bot should go online and receive all Discord events.\\n\\n:::info Topologically-aware\\nThis function is only usable if called within the context of Session.login \\n:::\\n\\n\\n    ","params":[],"returns":[{"desc":"","lua_type":"(error: string?)"}],"function_type":"static","source":{"line":143,"path":"src/Structure/Session.lua"}},{"name":"listen","desc":"Listen to a given `Event` and calls a callback when it is emitted.\\n\\n### Usage Example:\\n\\n```lua\\nSession.listen(Events.messageCreate, function(message)\\n    print(message.author.ID)\\nend)\\n```\\n\\n    ","params":[{"name":"event","desc":"An event object. All events are listed in `Events.lua` file.","lua_type":"{}"},{"name":"callback","desc":"","lua_type":"(args...) -> ()"}],"returns":[],"function_type":"static","source":{"line":177,"path":"src/Structure/Session.lua"}},{"name":"registerGlobalCommand","desc":"Register a global application command in your BOT.\\n\\n    ","params":[{"name":"data","desc":"A command object created by Lumi builders.","lua_type":"Command"}],"returns":[{"desc":"","lua_type":"string?\\r\\n"}],"function_type":"static","source":{"line":191,"path":"src/Structure/Session.lua"}},{"name":"registerGuildCommand","desc":"Register a guild-only application command in your BOT.\\n\\n    ","params":[{"name":"guildID","desc":"The ID of the guild.","lua_type":"string"},{"name":"data","desc":"A command object created by Lumi builders.","lua_type":"Command"}],"returns":[{"desc":"","lua_type":"string?\\r\\n"}],"function_type":"static","source":{"line":207,"path":"src/Structure/Session.lua"}},{"name":"deleteGlobalCommand","desc":"Delete a global application command in your BOT.\\n\\n    ","params":[{"name":"ID","desc":"The ID of the command to be deleted.","lua_type":"string"}],"returns":[{"desc":"","lua_type":"string?\\r\\n"}],"function_type":"static","source":{"line":221,"path":"src/Structure/Session.lua"}},{"name":"replyInteraction","desc":"Send a response to an interaction.\\n\\n    ","params":[{"name":"interactionID","desc":"The ID of the interaction.","lua_type":"string"},{"name":"token","desc":"The interaction token.","lua_type":"string"},{"name":"data","desc":"The response data or message.","lua_type":"Data | string"}],"returns":[],"function_type":"static","source":{"line":238,"path":"src/Structure/Session.lua"}},{"name":"sendMessage","desc":"Sends a message in the given channel.  \\nThe content table needs to be created using builders available in Lumi.\\n\\n\\n:::info Topologically-aware\\nThis function is only usable if called within the context of Session.login \\n:::\\n\\n    ","params":[{"name":"channelID","desc":"The ID of the channel.","lua_type":"string"},{"name":"data","desc":"The message content.","lua_type":"string | {}"},{"name":"replyTo","desc":"The ID of the message to reply to.","lua_type":"string?"}],"returns":[{"desc":"","lua_type":"(error: string?)"}],"function_type":"static","source":{"line":266,"path":"src/Structure/Session.lua"}},{"name":"getGuild","desc":"","params":[{"name":"ID","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Guild\\r\\n"}],"function_type":"static","source":{"line":92,"path":"src/Structure/State.lua"}},{"name":"getUser","desc":"","params":[{"name":"ID","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"User\\r\\n"}],"function_type":"static","source":{"line":97,"path":"src/Structure/State.lua"}},{"name":"getChannel","desc":"","params":[{"name":"ID","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Channel\\r\\n"}],"function_type":"static","source":{"line":102,"path":"src/Structure/State.lua"}},{"name":"getRole","desc":"","params":[{"name":"ID","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"Role\\r\\n"}],"function_type":"static","source":{"line":107,"path":"src/Structure/State.lua"}}],"properties":[{"name":"state","desc":"The current state for all data in session.\\n\\n    ","lua_type":"State","source":{"line":90,"path":"src/Structure/Session.lua"}},{"name":"identify","desc":"    \\n\\nInformation useful for handshake with Discord.\\nCheck docs for more information about this.\\n\\n    ","lua_type":"Identify","source":{"line":102,"path":"src/Structure/Session.lua"}}],"types":[],"name":"Session","desc":"Main interface for interacting with Discord.","source":{"line":59,"path":"src/Structure/Session.lua"}}')}}]);