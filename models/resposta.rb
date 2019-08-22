class Resposta < Sequel::Model
  many_to_one :aplicacao, key: :aplicacao_teste_id
  many_to_one :alternativa
  def questao
    id = alternativa_dataset.select(:questao_id)
    Questao.find(id:id)
  end
  def questao_dataset
    id = alternativa_dataset.select(:questao_id)
    Questao.where(id:id)
  end
end
