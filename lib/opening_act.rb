require_relative 'opening_act/version.rb'
require_relative 'opening_act/input.rb'
require_relative 'opening_act/output.rb'
require_relative 'opening_act/template.rb'
require_relative 'opening_act/verify.rb'
require 'fileutils'

# Main class for OpeningAct
class OpeningAct
  extend Inputable, Outputable, Verifiable

  def self.perform(name, test_name)
    return leave_the_stage unless play_on?

    setup(name, test_name)
    add_overwrite_rename_or_quit while directory_exists?
    take_the_stage
    create_project_files
    curtain_call
  end

  private_class_method

  def self.add_overwrite_rename_or_quit
    output_directory_exists_commands
    command = command_input
    determine_action(command)
  end

  def self.add_to_existing_dir
    puts "> Files will be added to existing directory '#{template.name}'."
    puts
  end

  def self.correct_test_name?(test_type)
    %w[minitest rspec].include?(test_type[1..-1])
  end

  def self.create_project_files
    template.create
    template.remove_extra_files
    template.rename_files
    template.initiate_project
  end

  def self.determine_action(command)
    case command
    when 'add'              then add_to_existing_dir
    when 'overwrite'        then overwrite_existing_dir
    when 'rename'           then rename_project
    when 'quit' || 'q'      then leave_the_stage
    else 'no command'
    end
  end

  def self.directory_exists?
    Dir.exist? name
  end

  def self.flag?(test_type)
    test_type[0] == '-'
  end

  def self.overwrite_existing_dir
    FileUtils.rm_rf(template.name)

    puts "> '#{template.name}' will be overwritten."
    puts
  end

  def self.play_on?
    puts '> Running this command will initiate a git project.'
    puts "> Make sure you aren't running this inside another git project."
    puts '> Type QUIT if you wish to stop. Otherwise, click Enter.'

    !%w[quit q].include?(user_input.downcase)
  end

  def self.rename_project
    template.name = project_name_input
    puts "> Your project has been renamed to '#{template.name}'."
  end

  def self.setup(project_name, test_type)
    project_name = project_name_input unless valid_name?(project_name)
    test_type = test_type_input unless valid_test?(test_type)

    @@template = Template.new(project_name, test_type)
  end

  def self.template
    @@template
  end
end
