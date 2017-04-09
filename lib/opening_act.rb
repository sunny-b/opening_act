require_relative 'opening_act/version.rb'
require_relative 'opening_act/input.rb'
require_relative 'opening_act/output.rb'
require_relative 'opening_act/template.rb'
require_relative 'opening_act/verify.rb'
require 'fileutils'

# Main class for OpeningAct
class OpeningAct
  extend Inputable
  extend Outputable
  extend Verifiable

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
    directory_exists_commands
    command = command_input
    determine_action(command)
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
    when 'add'              then add_confirmation
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

    overwrite_confirmation
  end

  def self.play_on?
    new_git_confirmation

    !%w[quit q].include?(user_input.downcase)
  end

  def self.rename_project
    template.name = project_name_input
    rename_confirmation
  end

  def self.setup(project_name, test_type)
    project_name = project_name_input unless valid_name?(project_name)
    test_type = test_type_input unless valid_test?(test_type)

    @template = Template.new(project_name, test_type)
  end

  class << self
    attr_reader :template
  end
end
