require_relative 'application'
require 'yaml'
require 'sequel'
require 'rack-flash'

# Load DB
DB = Sequel.connect(adapter: 'postgres', database: 'questionarios', user: 'postgres')
Sequel.extension :migration

# Run migrations
if DB
  Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), 'migrations'))
end

# Load controllers
Dir[File.join(File.dirname(__FILE__), 'controllers', '**', '*.rb')].sort.each {|file| require file }
# Load models
Dir[File.join(File.dirname(__FILE__), 'models', '**', '*.rb')].sort.each {|file| require file }
# Load helpers
Dir[File.join(File.dirname(__FILE__), 'helpers', '**', '*.rb')].sort.each {|file| require file }

use Rack::Reloader, 0
use Rack::Static, :urls => ["/css", "/js", "/img", "/temp"], :root => "public"

use Rack::Session::Cookie, secret: "IdoNotHaveAnySecret"
use Rack::Flash, accessorize: [:notice, :error, :success]

# map '/session' do
#   run App::Session
# end
#
# map '/' do
#   run App::Main
# end

run Application.new
