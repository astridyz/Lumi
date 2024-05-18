--!strict
local Lumi = require 'init'
local Client = Lumi.client()
local Events = Lumi.events

Client.login('MTIzNTk3MTAyMzQ0MzMzMzIxMQ.GPzphV.fbAIyQ85wFfUxG1L_1Fuf6o6QU3fyUh-yizNg4')
Client.connect()

Client.listen(Events.messageCreate, function(message)
    if message.content == 'Hi' then
        message.reply('Hey there!')
    end
end)