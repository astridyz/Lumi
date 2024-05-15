local Lumi = require 'init'
local Client = Lumi.client.wrap()
local Events = Lumi.events()

Client.login('MTIzNTk3MTAyMzQ0MzMzMzIxMQ.GPzphV.fbAIyQ85wFfUxG1L_1Fuf6o6QU3fyUh-yizNg4')
Client.connect()

Client.listen(Events.messageCreate, function(message)
    print(message.content())
end)