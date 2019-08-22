class AplicacoesController < BaseController
  class << self
    attr_accessor :aplicacao

    # Index - Resultados das aplicações
    # New   - Mostra os testes e seleciona qual aplicar
    # Apply - Começa a apicar o teste selecionado

    def show(id)
      AplicacoesController.aplicacao = AplicacaoTeste.find(id:id)
      render("aplicacoes/show.html.erb")
    end

    def iniciar(teste_id)
      AplicacaoTeste.create(
        teste_id: teste_id,
        candidato_id: Current.user.id,
        data: Date.today,
        hora_inicio: DateTime.now,
      )
    end

    def aplicar(id)
      AplicacoesController.aplicacao = AplicacaoTeste.find(id:id)
      if aplicacao.questoes_faltantes.empty?
        aplicacao.finalizar!
        Rack::Response.new do |response|
          response.redirect("/aplicacoes/#{aplicacao.id}")
        end
      else
        render("aplicacoes/aplicar.html.erb")
      end
    end

    def index
      Rack::Response.new(render("aplicacoes/index.html.erb"))
    end

    def testes
      Teste.all
    end

  end
end
