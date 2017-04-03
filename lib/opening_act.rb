require_relative "opening_act/version"
require 'pry'
require 'fileutils'

class OpeningAct
  PROJECT_TEMPLATE = File.expand_path('../opening_act/templates', __FILE__)

  def initialize(name, test_name)
    setup(name, test_name)
  end

  def perform
    FileUtils.copy_entry PROJECT_TEMPLATE, name

    remove_files(test_or_spec == 'rspec' ? 'test' : 'spec');
    rename_template_files

  end

  private

  def name
    @name
  end

  def test_or_spec
    @test_type
  end

  def setup(project_name, test_type)
    project_name = get_project_name unless valid_name?(project_name)
    test_type = get_test_type unless valid_test?(test_type)

    @name = project_name
    @test_type = test_type[1..-1]
  end

  def get_project_name
    loop do
      puts "> What do you want to name your project?"
      project_name = STDIN.gets.chomp

      return project_name unless project_name.empty?
      puts "Invalid entry."
    end
  end

  def get_test_type
    tests = ['minitest', 'rspec']
    loop do
      puts "> Do you prefer rspec or minitest?"
      test_type = STDIN.gets.chomp

      return test_type if tests.include? test_type
      puts "Invalid entry."
    end
  end

  def valid_test?(test_type)
    !test_type.nil? && ['minitest', 'rspec'].include?(test_type[1..-1])
  end

  def valid_name?(project_name)
    !project_name.nil? && !(project_name[0] == '-')
  end

  def remove_files(test_type)
    FileUtils.rm_rf("#{name}/#{test_type}")
    FileUtils.rm Dir.glob("#{name}/*_#{test_type}")
  end

  def rename_template_files
    File.rename("#{name}/new_app.rb", "#{name}/#{name}.rb")
    Dir.glob("#{name}/*_*").each do |file|
      File.rename(file, file[0..-6])
    end
  end

  def encore
    puts 'The Opening Act has performed.'
    puts "Your project folder #{name} has be created."
    puts "You're now ready for the main event."
  end
end
