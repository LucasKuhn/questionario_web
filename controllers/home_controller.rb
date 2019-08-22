class HomeController < BaseController
  class << self
    def index
      Rack::Response.new(render("home/index.html.erb"))
    end
  end
end
