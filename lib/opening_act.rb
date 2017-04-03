require_relative "opening_act/version"
require 'fileutils'

class OpeningAct
  PROJECT_TEMPLATE = File.expand_path('../opening_act/templates', __FILE__)

  def initialize(name, test_name)
    setup(name, test_name)
  end

  def perform
    check_if_directory_exists
    remove_files(test_or_spec == 'rspec' ? 'test' : 'spec');
    rename_template_files
    initiate_git
    curtain_call
  end

  private

  def add_to_existing_dir
    create_template_files

    puts "> Files were added to existing directory '#{name}'."
    puts
  end

  def check_if_directory_exists
    if Dir.exists? name
      output_directory_exists_commands
      command = get_command_input

      case command
      when 'add'       then add_to_existing_dir
      when 'overwrite' then overwrite_existing_dir
      when 'rename'    then rename_project
      when 'halt'      then leave_the_stage
      end
    else
      create_template_files
    end
  end

  def create_template_files
    FileUtils.copy_entry PROJECT_TEMPLATE, name
  end

  def curtain_call
    puts
    puts '> The Opening Act has performed.'
    puts "> Your project folder #{name} has be created."
    puts "> You're now ready for the main event."
  end

  def get_command_input
    appropriate_commands = %w(add overwrite halt rename)

    loop do
      command = STDIN.gets.chomp.downcase
      return command if appropriate_commands.include? command
      puts '> Invalid entry. Please enter ADD/OVERWRITE/HALT/RENAME'
    end
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

  def initiate_git
    Dir.chdir "#{name}"
    `git init`
  end

  def leave_the_stage
    puts '> The Opening Act was forced to leave the stage early.'
    puts '> Your project folder was not created.'
    exit
  end

  def name
    @name
  end

  def output_directory_exists_commands
    puts "> It appears another directory by this name already exists."
    puts "> Do you wish to:"
    puts "    ADD to it"
    puts "    OVERWRITE it"
    puts "    RENAME your project"
    puts "    HALT this program"
  end

  def overwrite_existing_dir
    FileUtils.rm_rf("#{name}")
    create_template_files

    puts "> '#{name}' has been overwritten."
    puts
  end

  def remove_files(test_type)
    FileUtils.rm_rf("#{name}/#{test_type}")
    FileUtils.rm Dir.glob("#{name}/*_#{test_type}")
  end

  def rename_project
    project_name = get_project_name
    @name = project_name
    puts "> Your project has been renamed to #{name}."
    check_if_directory_exists
  end

  def rename_template_files
    File.rename("#{name}/new_app.rb", "#{name}/#{name}.rb")
    Dir.glob("#{name}/*_*").each do |file|
      File.rename(file, file[0..-6])
    end
  end

  def setup(project_name, test_type)
    project_name = get_project_name unless valid_name?(project_name)
    test_type = get_test_type unless valid_test?(test_type)

    @name = project_name
    @test_type = test_type[1..-1]
  end

  def test_or_spec
    @test_type
  end

  def valid_name?(project_name)
    !project_name.nil? && !(project_name[0] == '-')
  end

  def valid_test?(test_type)
    !test_type.nil? && ['minitest', 'rspec'].include?(test_type[1..-1])
  end
end
