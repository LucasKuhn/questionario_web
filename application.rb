require 'erb'
require 'byebug'
require 'sequel'

class Application
  def call(env)

    # Redireciona para Login se não está logado
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
        LoginController.login(env,request.params)
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
      if request.get?
        CandidatosController.index
      elsif request.post?
        CandidatosController.create(request.params)
      end
    when "/candidatos/new"
      CandidatosController.new
    when /\/candidatos\/(\d+)/
      CandidatosController.show($1)

      # Elaboradores
    when "/elaboradores"
      if request.get?
        ElaboradoresController.index
      elsif request.post?
        ElaboradoresController.create(request.params)
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
        TestesController.create(request.params)
      end
    when "/testes/new"
      TestesController.new
    when /\/testes\/(\d+)$/
      TestesController.show($1)

      # Questões
    when /\/testes\/(\d+)\/questoes\/new/
      QuestoesController.new($1)
    when /\/testes\/(\d+)\/questoes/
      if request.get?
        QuestoesController.index
      elsif request.post?
        QuestoesController.create(request.params,$1)
      end
    when /\/questoes\/(\d+)/
      if request.get?
        QuestoesController.show($1)
      elsif request.delete?
        QuestoesController.delete($1)
      end

      # Aplicações de Testes
    when "/aplicacoes"
      AplicacoesController.index
    when "/aplicacoes/new"
      AplicacoesController.new
    when "/aplicacoes/iniciar"
      AplicacoesController.iniciar(request.params['teste'])
    when /\/aplicacoes\/(\d+)\/aplicar/
      AplicacoesController.aplicar($1)
    when /\/aplicacoes\/(\d+)\/finalizar/
      AplicacoesController.finalizar(request.params,$1)
    when /\/aplicacoes\/(\d+)/
      AplicacoesController.show($1)

    # 404 - Not Found
    else
      response = Rack::Response.new
      response.status = 404
      response.write("Not found")
      response.finish
      [404, {'Content-Length' => '9'}, ['Not found']]
    end
  end

end
