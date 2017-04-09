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

  def output_directory_exists_commands
    puts '> It appears another directory by this name already exists.'
    puts '> Do you wish to:'
    puts '    ADD to it'
    puts '    OVERWRITE it'
    puts '    RENAME your project'
    puts '    QUIT this program'
  end

  def take_the_stage
    puts '> The Opening Act has begun to play. This may take a moment.'
  end
end
