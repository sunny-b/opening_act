# Module containing method for user inputs
module Inputable
  def command_input
    appropriate_commands = %w[add overwrite q quit rename]

    loop do
      command = user_input.downcase
      return command if appropriate_commands.include? command
      puts '> Invalid entry. Please enter ADD/OVERWRITE/QUIT/RENAME'
    end
  end

  def project_name_input
    loop do
      puts '> What do you want to name your project?'
      project_name = user_input

      return project_name if valid_name?(project_name)
      puts '> Invalid characters. Please try again'
    end
  end

  def test_type_input
    loop do
      puts '> Do you prefer rspec or minitest?'
      test_type = '-' + user_input.downcase

      return test_type if valid_test? test_type
      puts '> Invalid entry.'
    end
  end

  def user_input
    $stdin.gets.chomp
  end
end
