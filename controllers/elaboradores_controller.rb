class ElaboradoresController < BaseController
  class << self
    attr_accessor :elaborador

    def new
      render("elaboradores/new.html.erb")
    end

    def index
      Rack::Response.new(render("elaboradores/index.html.erb"))
    end

    def show(id)
      ElaboradoresController.elaborador = Elaborador.find(id:id)
      render("elaboradores/show.html.erb")
    end

    def elaboradores
      Elaborador.all
    end
  end
end
