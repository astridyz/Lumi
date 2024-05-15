local Message = require 'src/Structure/Serialized/message'
export type Message = Message.Message

return {
    class = require 'src/Component',
    client = require 'src/structure/Client'
}