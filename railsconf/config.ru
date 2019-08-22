require 'pp'

class Application
  def call(env)
    response = Rack::Response.new
    # pp env
    # p env["REQUEST_METHOD"]
    # p env["REQUEST_URI"]
    # p env["PATH_INFO"]
    # p env["rack.input"]
    request = Rack::Request.new(env)
    if request.path_info.match %r{/bot/(\d+)}
      if request.get?
        bot = Database.find($1)
        [200,{},[bot.to_s]]
      elsif request.post?
        bot = request.body.read
        Database.save($1,bot)
        [200,{},["Wrote bot #{$1}"]]
      end


      [403,{},["Beep boop intruder on #{$1}"]]
    else
      [200,{},["Greetings"]]
    end

  end
end

class Status
  def call(env)
    [200,{},["Status"]]
  end
end

# map "/" do
#   run Application.new
# end
#
# map "/status" do
#   run Status.new
# end

run Rack::URLMap.new(
  "/status" => Status.new,
  "/"       => Application.new
)


# $ curl http://localhost:9292
# $ curl -X POST http://localhost:9292/bot/2 --data "\[*]/"
# $ curl http://localhost:9292/bot/2
