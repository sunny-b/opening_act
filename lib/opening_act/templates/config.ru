Dir.glob('*.rb') { |file| require_relative file }

set :run, false
set :environment, :production

run Sinatra::Application
