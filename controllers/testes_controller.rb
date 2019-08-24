class TestesController < BaseController
  class << self
    attr_accessor :teste

    def new
      render("testes/new.html.erb")
    end

    def create(params)
      teste = Teste.new(params)
      if teste.valid?
        teste.save
        return [ 302, {'Location' =>"/testes/#{teste.id}"}, [] ]
      else
        env['x-rack.flash'].error = teste.errors.full_messages
        return [ 302, {'Location' =>"/testes/new"}, [] ]
      end
    end

    def index
      Rack::Response.new(render("testes/index.html.erb"))
    end

    def show(id)
      TestesController.teste = Teste.find(id:id)
      render("testes/show.html.erb")
    end

    def testes
      Teste.all
    end
  end
end
