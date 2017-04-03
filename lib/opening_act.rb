require_relative "opening_act/version"
require 'pry'
require 'fileutils'

class OpeningAct
  def initialize(name, test_name)
    setup(name, test_name)
  end

  def perform
    project_path = File.expand_path('../opening_act/templates/general', __FILE__)
    FileUtils.copy_entry project_path, @name
  end

  private

  def setup(project_name, test_type)
    project_name = get_name unless valid_name?(project_name)
    test_type = get_test_type unless valid_test?(test_type)

    @name = project_name
    @test_type = test_type[1..-1]
  end

  def get_name
    loop do
      puts "What do you want to name your project?"
      name = STDIN.gets.chomp

      return name unless name.empty?
      puts "Invalid entry."
    end
  end

  def get_test_type
    tests = ['minitest', 'rspec']
    loop do
      puts "Do you prefer rspec or minitest?"
      type = STDIN.gets.chomp

      return type if tests.include? type
      puts "Invalid entry."
    end
  end

  def valid_test?(test_type)
    !test_type.nil? && ['minitest', 'rspec'].include?(test_type[1..-1])
  end

  def valid_name?(project_name)
    !project_name.nil? && !(project_name[0] == '-')
  end
end
