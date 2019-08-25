require 'sequel'
require 'rack-flash'
require 'erb'
require 'byebug'
require_relative 'application'

# Load DB
if ENV['RACK_ENV'] == 'production'
  DB = Sequel.connect(ENV['DATABASE_URL'])
else
  DB = Sequel.connect(adapter: 'postgres', host: 'localhost', database: 'questionarios', user: 'postgres')
end
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

run Application.new
