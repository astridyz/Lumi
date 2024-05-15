local Lumi = require 'init'
local Client = Lumi.client.wrap()

Client.login('MTIzNTk3MTAyMzQ0MzMzMzIxMQ.GPzphV.fbAIyQ85wFfUxG1L_1Fuf6o6QU3fyUh-yizNg4')
Client.connect()

Client.listenOnce('messageCreate', function(message: Lumi.Message)
    print(message.content())
end)