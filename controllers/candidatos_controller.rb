class CandidatosController < BaseController
  class << self
    attr_accessor :candidato

    def index
      Rack::Response.new(render("candidatos/index.html.erb"))
    end

    def new
      render("candidatos/new.html.erb")
    end

    def create(params)
      candidato = Candidato.new(params)
      if candidato.valid?
        candidato.save
        return [302, {'Location' =>"/candidatos/#{candidato.id}"}, [] ]
      else
        env['x-rack.flash'].error = candidato.errors.full_messages
        return [302, {'Location' =>"/candidatos/new"}, [] ]
      end
    end

    def show(id)
      CandidatosController.candidato = Candidato.find(id:id)
      render("candidatos/show.html.erb")
    end

    def edit(id)
      CandidatosController.candidato = Candidato.find(id:id)
      render("candidatos/edit.html.erb")
    end

    def update(id, params)
      candidato = Candidato.find(id:id)
      candidato.update(params)
      return [ 302, {'Location' =>"/candidatos/#{candidato.id}"}, [] ]
    end

    def candidatos
      Candidato.all
    end
  end
end
