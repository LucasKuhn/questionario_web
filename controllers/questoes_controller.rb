class QuestoesController < BaseController
  class << self
    attr_accessor :questao
    attr_accessor :teste

    def new(teste_id)
      QuestoesController.teste = Teste.find(id:teste_id)
      render("questoes/new.html.erb")
    end

    def index
      Rack::Response.new(render("questoes/index.html.erb"))
    end

    def show(id)
      QuestoesController.questao = Questao.find(id:id)
      prepare_image(questao)
      render("questoes/show.html.erb")
    end

    def create(params,teste_id)
      if params["image_file"]
        filename = params["image_file"][:filename]
        file = params["image_file"][:tempfile].read
      else
        filename = nil
        file = nil
      end
      questao = Questao.new(
        texto: params["texto"],
        nome_ilustracao: filename,
        ilustracao: file,
        alternativas_attributes: params["alternativas_attributes"],
        teste_id: teste_id
      )
      if questao.valid?
        questao.save
        return [ 302, {'Location' =>"/testes/#{teste_id}"}, [] ]
      else
        FlashMessages.add(questao.errors.full_messages)
        return [ 302, {'Location'=>"/testes/#{teste_id}/questoes/new"}, [] ]
      end
    end

    def delete(id)
      questao = Questao.find(id:id)
      questao.destroy
      return [ 302, {'Location' =>"/testes/#{questao.teste.id}"}, [] ]
    end

    def questoes
      Questao.all
    end

    def prepare_image(questao)
      filename = questao.nome_ilustracao
      file = questao.ilustracao
      unless File.exist?("./public/img/#{filename}")
        File.open("./public/img/#{filename}", 'wb') { |new_file| new_file.write(file.to_s) }
      end
    end

    def load_image(id)
      questao = Questao.find(id:id)
      content_type ||= Rack::Mime.mime_type(::File.extname('imagem.png'))
      content_disposition ||= File.basename('imagem.png')

      response = Rack::Response.new
      response.body = questao.ilustracao
      response['Content-Type'] = content_type
      response['Content-Disposition'] = content_disposition
      response.status = 200
      response.finish
    end
  end
end
