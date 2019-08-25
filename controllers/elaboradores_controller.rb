class ElaboradoresController < BaseController
  class << self
    attr_accessor :elaborador

    def index
      Rack::Response.new(render("elaboradores/index.html.erb"))
    end

    def new
      render("elaboradores/new.html.erb")
    end

    def create(params)
      elaborador = Elaborador.new(params)
      if elaborador.valid?
        elaborador.save
        return [ 302, {'Location' =>"/elaboradores/#{elaborador.id}"}, [] ]
      else
        env['x-rack.flash'].error = elaborador.errors.full_messages
        return [ 302, {'Location' =>"/elaboradores/new"}, [] ]
      end
    end

    def show(id)
      ElaboradoresController.elaborador = Elaborador.find(id:id)
      render("elaboradores/show.html.erb")
    end

    def edit(id)
      ElaboradoresController.elaborador = Elaborador.find(id:id)
      render("elaboradores/edit.html.erb")
    end

    def update(id, params)
      elaborador = Elaborador.find(id:id)
      elaborador.update(params)
      return [ 302, {'Location' =>"/elaboradores/#{elaborador.id}"}, [] ]
    end

    def elaboradores
      Elaborador.all
    end
  end
end
