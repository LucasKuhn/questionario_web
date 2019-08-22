class FlashMessages
  class << self
    attr_accessor :messages

    def any?
      self.messages
    end

    def add(message)
      messages = self.messages ? self.messages : Array.new
      messages << message
      self.messages = messages
    end

    def read
      if any?
        str = ""
        self.messages.each do |message|
          str += message.first
        end
        self.messages = nil
        return str
      else
        return nil
      end
    end
  end
end
