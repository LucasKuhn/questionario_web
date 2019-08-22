require 'erb'

class Greeter
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render("index.html.erb"))
    # when "/change" then Rack::Response.new(request.params["name"])
    when "/change"
      Rack::Response.new do |response|
        response.set_cookie("greet", @request.params["name"])
        response.redirect("/")
      end
    else Rack::Response.new("Not Found", 404)
    end
    # ['200', {'Content-Type' => 'text/plain'}, ['Hello Worldz']]
  end

  def greet_name
    @request.cookies["greet"] || "World"
  end

  def render(template)
    # ERB.new(File.read(path )).result(binding)
    path = File.expand_path("../views/#{template}/", __FILE__)
    ERB.new(File.read(path )).result
  end

end
