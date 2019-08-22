require "greeter"

use Rack::Reloader, 0
use Rack::Static

run Greeter
