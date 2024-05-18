--!strict
local Lumi = require 'init'
local Session = Lumi.session()
local Events = Lumi.events

Session.login('MTIzNTk3MTAyMzQ0MzMzMzIxMQ.GPzphV.fbAIyQ85wFfUxG1L_1Fuf6o6QU3fyUh-yizNg4')
Session.connect()

Session.listen(Events.messageCreate, function(message)
    print(message.guild.roles.get('1240749816242376744').name)
end)