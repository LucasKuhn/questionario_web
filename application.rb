require 'erb'
require 'byebug'
require 'sequel'

class Application
  def call(env)

    puts "requested path: #{env["PATH_INFO"]}"

    if env['rack.session'][:user_id] == nil && env["REQUEST_PATH"] != "/sign_in"
      return [ 302, {'Location' =>"/sign_in"}, ['Redirected to sign in'] ]
    else
      Current.set_user(env['rack.session'][:user_id])
    end


    request  = Rack::Request.new(env)

    case request.path

      # Authentication
    when "/sign_in"
      if request.post?
        user = LoginController.login(request.params)
        if user
          env['rack.session'][:user_id] = user.id
          return [ 302, {'Location' =>"/"}, [] ]
        else
          env['x-rack.flash'].error = 'Credenciais inválidas'
          env['rack.session'][:user_id] = nil
          return [ 302, {'Location' =>"/sign_in"}, [] ]
        end
      else
        LoginController.new(env)
      end
    when "/sign_out"
      env['rack.session'].clear
      return [ 302, {'Location' =>"/sign_in"}, [] ]

      # Home
    when "/"
      HomeController.index

      # Candidatos
    when "/candidatos"
      if request.post?
        candidato = Candidato.new(request.params)
        if candidato.valid?
          candidato.save
          [ 302, {'Location' =>"/candidatos/#{candidato.id}"}, [] ]
        else
          FlashMessages.add(candidato.errors.full_messages)
          Rack::Response.new do |response|
            response.redirect("/candidatos/new")
          end
        end
      else
        CandidatosController.index
      end
    when "/candidatos/new"
      CandidatosController.new
    when /\/candidatos\/(\d+)/
      CandidatosController.show($1)

      # Elaboradores
    when "/elaboradores"
      if request.post?
        elaborador = Elaborador.new(request.params)
        if elaborador.valid?
          elaborador.save
          [ 302, {'Location' =>"/elaboradores/#{elaborador.id}"}, [] ]
        else
          FlashMessages.add(elaborador.errors.full_messages)
          Rack::Response.new do |response|
            response.redirect("/elaboradores/new")
          end
        end
      else
        ElaboradoresController.index
      end
    when "/elaboradores/new"
      ElaboradoresController.new
    when /\/elaboradores\/(\d+)/
      ElaboradoresController.show($1)

      # Testes
    when "/testes"
      if request.get?
        TestesController.index
      elsif request.post?
        teste = Teste.new(request.params)
        if teste.valid?
          teste.save
          [ 302, {'Location' =>"/testes/#{teste.id}"}, [] ]
        else
          FlashMessages.add(teste.errors.full_messages)
          Rack::Response.new do |response|
            response.redirect("/testes/new")
          end
        end
      end
    when "/testes/new"
      TestesController.new
    when /\/testes\/(\d+)$/
      TestesController.show($1)

      # Questões
    when %r|/testes/(\d+)/questoes/new|
      QuestoesController.new($1)
    when %r|/testes/(\d+)/questoes|
      if request.get?
        QuestoesController.index
      elsif request.post?
        filename = request.params["image_file"][:filename]
        file = request.params["image_file"][:tempfile]
        questao = Questao.new(
          texto: request.params["texto"],
          nome_ilustracao: filename,
          ilustracao: file.read,
          alternativas_attributes: request.params["alternativas_attributes"],
          teste_id: $1
        )
        if questao.valid?
          questao.save
          [ 302, {'Location' =>"/testes/#{$1}"}, [] ]
        else
          FlashMessages.add(questao.errors.full_messages)
          return [ 302, {'Location'=>"/testes/#{$1}/questoes/new"}, [] ]
        end
      end
    when "/questoes/new"
      QuestoesController.new
    when /\/questoes\/(\d+)\/image/
      QuestoesController.load_image($1)
    when /\/questoes\/(\d+)/
      QuestoesController.show($1)

      # Aplicacoes
    when "/aplicacoes"
      AplicacoesController.index
    when "/aplicacoes/iniciar"
      aplicacao = AplicacoesController.iniciar(request.params['teste'])
      return [ 302, {'Location'=>"/aplicacoes/#{aplicacao.id}/aplicar"}, [] ]
    when /\/aplicacoes\/(\d+)\/aplicar/
      AplicacoesController.aplicar($1)

      # Resposta de uma aplicação de um teste
    when /\/aplicacoes\/(\d+)\/respostas/
      aplicacao = AplicacaoTeste.find(id:$1)
      aplicacao.add_resposta(request.params)
      return [ 302, {'Location'=>"/aplicacoes/#{$1}/aplicar"}, [] ]
    when /\/aplicacoes\/(\d+)/
      AplicacoesController.show($1)
    else
      response = Rack::Response.new
      response.status = 404
      response.write("Not found")
      response.finish
      [404, {'Content-Length' => '9'}, ['Not found']]
    end
  end

end
