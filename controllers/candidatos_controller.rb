class CandidatosController < BaseController
  class << self
    attr_accessor :candidato

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

    def index
      Rack::Response.new(render("candidatos/index.html.erb"))
    end

    def show(id)
      CandidatosController.candidato = Candidato.find(id:id)
      render("candidatos/show.html.erb")
    end

    def candidatos
      Candidato.all
    end
  end
end
