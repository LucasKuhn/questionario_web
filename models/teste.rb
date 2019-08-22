class Teste < Sequel::Model
  many_to_one :elaborador
  one_to_many :questoes, :class=>:Questao
end
