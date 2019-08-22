class Elaborador < Pessoa
  one_to_many :testes, :class=>:Teste
end
