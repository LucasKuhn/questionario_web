class AplicacaoTeste < Sequel::Model(:aplicacao_testes)
  many_to_one :pessoa, key: :candidato_id
  many_to_one :teste
  one_to_many :respostas, key: :aplicacao_teste_id
  plugin :nested_attributes
  nested_attributes :respostas

  def questoes_faltantes
    respondidas = []
    respostas.each { |resposta| respondidas << resposta.questao }
    teste.questoes - respondidas
  end

  def respostas_enviadas
    respostas.size + 1
  end

  def situacao
    if percentual_acerto >= teste.percentual_aprovacao
      'Aprovado ✅'
    else
      'Reprovado ❌'
    end
  end

  def total_perguntas
    teste.questoes.size
  end

  def get_question
    questoes_faltantes.sample
  end

  def seconds_remaining
    limit = hora_inicio + (teste.duracao * 60)
    result = ( limit - Time.now ).to_i
    result > 0 ? result : 0
  end

  def finalizar!
    corretas = 0
    respostas.each { |resposta| corretas += 1 if resposta.alternativa.correta }
    percentual_acerto = (corretas.to_f / total_perguntas) * 100
    self.update(hora_fim:DateTime.now,percentual_acerto:percentual_acerto)
  end

  def prepararar_imagens
    teste.questoes.each {|questao| questao.prepare_image!}
  end

end
