class Alternativa < Sequel::Model
  many_to_one :questao
end
