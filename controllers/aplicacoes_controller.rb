class AplicacoesController < BaseController
  class << self
    attr_accessor :aplicacao

    # Index - Resultados das aplicações
    # New   - Mostra os testes e seleciona qual aplicar
    # Apply - Começa a apicar o teste selecionado

    def index
      Rack::Response.new(render("aplicacoes/index.html.erb"))
    end

    def new
      Rack::Response.new(render("aplicacoes/new.html.erb"))
    end

    def show(id)
      AplicacoesController.aplicacao = AplicacaoTeste.find(id:id)
      render("aplicacoes/show.html.erb")
    end

    def iniciar(teste_id)
      aplicacao = AplicacaoTeste.create(
        teste_id: teste_id,
        candidato_id: Current.user.id,
        data: Date.today,
        hora_inicio: DateTime.now,
      )
      return [ 302, {'Location'=>"/aplicacoes/#{aplicacao.id}/aplicar"}, [] ]
    end

    def aplicar(id)
      AplicacoesController.aplicacao = AplicacaoTeste.find(id:id)
      aplicacao.prepararar_imagens
      render("aplicacoes/aplicar.html.erb")
    end

    def finalizar(params,aplicacao_id)
      aplicacao = AplicacaoTeste.find(id:aplicacao_id)
      aplicacao.teste.questoes.size
      respostas_attributes = []
      params.each do |key,value|
        respostas_attributes << {"alternativa_id"=>value}  if key.include?('alternativa_id')
      end
      aplicacao.update(respostas_attributes: respostas_attributes)
      aplicacao.finalizar!
      return [ 302, {'Location'=>"/aplicacoes/#{aplicacao_id}"}, [] ]
    end

    def testes
      Teste.all
    end

    def aplicacoes
      if Current.user.classificacao == 'Candidato'
        AplicacaoTeste.exclude(hora_fim: nil).where(candidato_id: Current.user.id)
      else
        AplicacaoTeste.exclude(hora_fim: nil)
      end
    end

  end
end
