class Questao < Sequel::Model(:questoes)
  many_to_one :teste, :class=>:Teste
  one_to_many :alternativas
  plugin :nested_attributes
  nested_attributes :alternativas
end
