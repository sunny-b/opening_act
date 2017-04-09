# Module containing methods that only output text
module Outputable
  def curtain_call
    puts
    puts '> The Opening Act has performed.'
    puts "> Your project folder '#{template.name}' was created."
    puts "> You're now ready for the main event."
  end

  def leave_the_stage
    puts '> The Opening Act was forced to leave the stage early.'
    puts '> Your project folder was not created.'
  end

  def directory_exists_commands
    puts '> It appears another directory by this name already exists.'
    puts '> Do you wish to:'
    puts '    ADD to it'
    puts '    OVERWRITE it'
    puts '    RENAME your project'
    puts '    QUIT this program'
  end

  def take_the_stage
    puts '> The Opening Act has begun to perform. This may take a moment.'
  end

  def add_confirmation
    puts "> Files will be added to existing directory '#{template.name}'."
    puts
  end

  def overwrite_confirmation
    puts "> '#{template.name}' will be overwritten."
    puts
  end

  def rename_confirmation
    puts "> Your project has been renamed to '#{template.name}'."
  end

  def nested_git_confirmation
    puts '> A git project already exists in this directory.'
    puts '> Running OpeningAct will create a nested git.'
    puts '> Type CONTINUE if you wish to continue. Otherwise, press Enter.'
  end
end
