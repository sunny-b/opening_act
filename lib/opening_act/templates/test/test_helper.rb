$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir.glob(File.expand_path('../../*.rb', __FILE__)).each do |file|
  require_relative file
end

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!
