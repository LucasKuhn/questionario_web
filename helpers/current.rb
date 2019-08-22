class Current
  class << self
    attr_accessor :user
    def set_user(user_id)
      self.user = Pessoa.find(id:user_id)
    end
  end
end
