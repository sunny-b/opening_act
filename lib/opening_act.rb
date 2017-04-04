require_relative 'opening_act/version'
require 'fileutils'

# Main class for OpeningAct
class OpeningAct
  PROJECT_TEMPLATE = File.expand_path('../opening_act/templates', __FILE__)

  def self.perform(name, test_name)
    return leave_the_stage unless play_on?

    setup(name, test_name)
    check_if_directory_exists
    remove_files(test_or_spec == 'rspec' ? 'test' : 'spec')
    rename_template_files
    initiate_git
    curtain_call
  end

  private_class_method

  def self.add_to_existing_dir
    create_template_files

    puts "> Files were added to existing directory '#{name}'."
    puts
  end

  def self.check_if_directory_exists
    if Dir.exist? name
      output_directory_exists_commands
      command = command_input
      determine_action(command)

    else
      create_template_files
    end
  end

  def self.command_input
    appropriate_commands = %w[add overwrite halt rename]

    loop do
      command = user_input.downcase
      return command if appropriate_commands.include? command
      puts '> Invalid entry. Please enter ADD/OVERWRITE/HALT/RENAME'
    end
  end

  def self.create_template_files
    FileUtils.copy_entry PROJECT_TEMPLATE, name
  end

  def self.curtain_call
    puts
    puts '> The Opening Act has performed.'
    puts "> Your project folder #{name} was created."
    puts "> You're now ready for the main event."
  end

  def self.determine_action(command)
    case command
    when 'add'       then add_to_existing_dir
    when 'overwrite' then overwrite_existing_dir
    when 'rename'    then rename_project
    when 'halt'      then leave_the_stage
    end
  end

  def self.initiate_git
    Dir.chdir name.to_s do
      `git init`
    end
  end

  def self.leave_the_stage
    puts '> The Opening Act was forced to leave the stage early.'
    puts '> Your project folder was not created.'
  end

  def self.name
    @@name
  end

  def self.project_name_input
    loop do
      puts '> What do you want to name your project?'
      project_name = user_input

      return project_name unless project_name.empty?
      puts 'Invalid entry.'
    end
  end

  def self.output_directory_exists_commands
    puts '> It appears another directory by this name already exists.'
    puts '> Do you wish to:'
    puts '    ADD to it'
    puts '    OVERWRITE it'
    puts '    RENAME your project'
    puts '    HALT this program'
  end

  def self.overwrite_existing_dir
    FileUtils.rm_rf(name.to_s)
    create_template_files

    puts "> '#{name}' has been overwritten."
    puts
  end

  def self.play_on?
    puts '> Running this command will initiate a git project.'
    puts "> Make sure you aren't running this inside another git project."
    puts '> Type HALT if you wish to stop. Otherwise, click Enter.'

    !user_input.casecmp('halt').zero?
  end

  def self.remove_files(test_type)
    FileUtils.rm_rf("#{name}/#{test_type}")
    FileUtils.rm Dir.glob("#{name}/*_#{test_type}")
  end

  def self.rename_project
    project_name = project_name_input
    @name = project_name
    puts "> Your project has been renamed to #{name}."
    check_if_directory_exists
  end

  def self.rename_template_files
    File.rename("#{name}/new_app.rb", "#{name}/#{name}.rb")
    Dir.glob("#{name}/*_*").each do |file|
      File.rename(file, file[0..-6])
    end
  end

  def self.setup(project_name, test_type)
    project_name = project_name_input unless valid_name?(project_name)
    test_type = test_type_input unless valid_test?(test_type)

    @@name = project_name
    @@test_type = test_type[1..-1]
  end

  def self.test_or_spec
    @@test_type
  end

  def self.test_type_input
    tests = %w[minitest rspec]
    loop do
      puts '> Do you prefer rspec or minitest?'
      test_type = user_input

      return test_type if tests.include? test_type
      puts 'Invalid entry.'
    end
  end

  def self.user_input
    $stdin.gets.chomp
  end

  def self.valid_name?(project_name)
    !project_name.nil? && project_name[0] != '-'
  end

  def self.valid_test?(test_type)
    !test_type.nil? && %w[minitest rspec].include?(test_type[1..-1])
  end
end
