class AplicacaoTeste < Sequel::Model(:aplicacao_testes)
  many_to_one :candidato
  many_to_one :teste
  one_to_many :respostas, key: :aplicacao_teste_id

  def questoes_faltantes
    respondidas = []
    respostas.each { |resposta| respondidas << resposta.questao }
    teste.questoes - respondidas
  end

  def respostas_enviadas
    respostas.size + 1
  end

  def total_perguntas
    # Artist.where(id: Album.select(:artist_id))
    # SELECT * FROM artists WHERE (id IN (
    #   SELECT artist_id FROM albums))

    # teste.questoes_dataset.where(id:[1,2])
    # teste.questoes_dataset.exclude(id:[1]).all
    # teste.questoes.size
    # teste.questoes_dataset.select(:id)
    teste.questoes.size
  end

  def get_question
    questoes_faltantes.sample
  end

  def time_remaining
    limit = hora_inicio + (teste.duracao * 60)
    result = ( limit - Time.now ) / 60
    result > 0 ? "#{result.to_i}:#{((result %1)*60).to_i}" : "0"
  end

  def finalizar!
    corretas = 0
    respostas.each { |resposta| corretas += 1 if resposta.alternativa.correta }
    percentual_acerto = (corretas.to_f / total_perguntas) * 100
    self.update(hora_fim:DateTime.now,percentual_acerto:percentual_acerto)
  end
end
