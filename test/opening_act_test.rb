require 'test_helper'
require 'fileutils'

class OpeningActTest < Minitest::Test
  def setup
    $stdout = StringIO.new
  end

  def test_that_it_has_a_version_number
    refute_nil OpeningAct::VERSION
  end

  def test_setup_halt
    $stdin = StringIO.new('halt')
    OpeningAct.perform('', '')
    assert $stdout.string.match(/this command will initiate a git project./)
    assert $stdout.string.match(/The Opening Act was forced to leave the stage early./)
    refute $stdout.string.match(/The Opening Act has performed./)
  end

  def test_success_minitest
    $stdin = StringIO.new('\n')
    OpeningAct.perform('bubbles', '-minitest')
    assert $stdout.string.match(/this command will initiate a git project./)
    assert $stdout.string.match(/The Opening Act has performed./)
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 1, Dir.glob('bubbles/test').length
    assert_equal 1, Dir.glob('bubbles/Gemfile').length
    assert_equal 1, Dir.glob('bubbles/Rakefile').length
  end

  def test_success_rspec
    $stdin = StringIO.new('\n')
    OpeningAct.perform('bubbles', '-rspec')
    assert $stdout.string.match(/this command will initiate a git project./)
    assert $stdout.string.match(/The Opening Act has performed./)
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 1, Dir.glob('bubbles/spec').length
    assert_equal 1, Dir.glob('bubbles/Gemfile').length
    assert_equal 1, Dir.glob('bubbles/Rakefile').length
  end

  def test_user_input
    $stdin = StringIO.new('test')
    assert_equal 'test', OpeningAct.send(:user_input)
  end

  def test_command_input_add
    $stdin = StringIO.new('add')
    assert_equal 'add', OpeningAct.send(:command_input)
  end

  def test_command_input_rename
    $stdin = StringIO.new('rename')
    assert_equal 'rename', OpeningAct.send(:command_input)
  end

  def test_command_input_halt
    $stdin = StringIO.new('halt')
    assert_equal 'halt', OpeningAct.send(:command_input)
  end

  def test_command_input_overwrite
    $stdin = StringIO.new('overwrite')
    assert_equal 'overwrite', OpeningAct.send(:command_input)
  end

  def test_output_commands
    assert_nil OpeningAct.send(:output_directory_exists_commands)
    assert $stdout.string.match(/It appears another directory by this name already exists./)
    assert $stdout.string.match(/ADD to it/)
    assert $stdout.string.match(/OVERWRITE it/)
    assert $stdout.string.match(/RENAME your project/)
    assert $stdout.string.match(/HALT this program/)
  end

  def test_determine_action_wrong_command
    assert_equal 'no command', OpeningAct.send(:determine_action, nil)
  end

  def test_directory_already_exists_halt
    $stdin = StringIO.new('\n')
    OpeningAct.perform('bubbles', '-minitest')

    $stdin = StringIO.new('halt')
    OpeningAct.send(:check_if_directory_exists)

    assert $stdout.string.match(/It appears another directory by this name already exists./)
    assert $stdout.string.match(/The Opening Act was forced to leave the stage early./)
  end

  def test_directory_already_exists_add
    $stdin = StringIO.new('\n')
    OpeningAct.perform('bubbles', '-minitest')

    $stdin = StringIO.new('add')
    OpeningAct.send(:check_if_directory_exists)

    assert $stdout.string.match(/It appears another directory by this name already exists./)
    assert $stdout.string.match(/Files were added to existing directory 'bubbles'./)
  end

  def test_directory_already_exists_overwrite
    $stdin = StringIO.new('\n')
    OpeningAct.perform('bubbles', '-minitest')

    $stdin = StringIO.new('overwrite')
    OpeningAct.send(:check_if_directory_exists)

    assert $stdout.string.match(/It appears another directory by this name already exists./)
    assert $stdout.string.match(/'bubbles' has been overwritten./)
  end

  def test_rename_project_to_bubbles
    assert_equal 'test', OpeningAct.send(:rename_to, 'test')
    assert_equal 'test', OpeningAct.send(:name)

    $stdin = StringIO.new('bubbles')
    assert_equal 'bubbles', OpeningAct.send(:rename_project)
    assert_equal 'bubbles', OpeningAct.send(:name)

    assert $stdout.string.match(/What do you want to name your project?/)
    assert $stdout.string.match(/Your project has been renamed to 'bubbles'./)
  end

  def test_rename_project_success
    OpeningAct.send(:setup, 'test', '-minitest')

    $stdin = StringIO.new('bubbles')
    OpeningAct.send(:determine_action, 'rename')
    assert_equal 'bubbles', OpeningAct.send(:name)

    assert $stdout.string.match(/What do you want to name your project?/)
    assert $stdout.string.match(/Your project has been renamed to 'bubbles'./)
    assert_equal 1, Dir.glob('bubbles').length
  end

  def test_setup
    OpeningAct.send(:setup, 'test', '-minitest')
    assert_equal 'test', OpeningAct.send(:name)
    assert_equal 'minitest', OpeningAct.send(:test_or_spec)
  end

  def test_remove_files_bubbles_test
    OpeningAct.send(:setup, 'bubbles', '-minitest')

    OpeningAct.send(:check_if_directory_exists)
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 5, Dir.glob('bubbles/*_*').length

    OpeningAct.send(:remove_files, 'spec')
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 3, Dir.glob('bubbles/*_*').length
    assert_equal 1, Dir.glob('bubbles/test').length
    assert_equal 1, Dir.glob('bubbles/Gemfile_test').length
    assert_equal 1, Dir.glob('bubbles/Rakefile_test').length
  end

  def test_remove_files_bubbles_spec
    OpeningAct.send(:setup, 'bubbles', '-rspec')

    OpeningAct.send(:check_if_directory_exists)
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 5, Dir.glob('bubbles/*_*').length

    OpeningAct.send(:remove_files, 'test')
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 3, Dir.glob('bubbles/*_*').length
    assert_equal 1, Dir.glob('bubbles/spec').length
    assert_equal 1, Dir.glob('bubbles/Gemfile_spec').length
    assert_equal 1, Dir.glob('bubbles/Rakefile_spec').length
  end

  def test_rename_files_bubbles_spec
    OpeningAct.send(:setup, 'bubbles', '-rspec')
    OpeningAct.send(:check_if_directory_exists)
    OpeningAct.send(:remove_files, 'test')

    OpeningAct.send(:rename_template_files)
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 0, Dir.glob('bubbles/*_*').length
    assert_equal 1, Dir.glob('bubbles/spec').length
    assert_equal 1, Dir.glob('bubbles/Gemfile').length
    assert_equal 1, Dir.glob('bubbles/Rakefile').length
    assert_equal 1, Dir.glob('bubbles/bubbles.rb').length
  end

  def test_rename_files_bubbles_test
    OpeningAct.send(:setup, 'bubbles', '-minitest')
    OpeningAct.send(:check_if_directory_exists)
    OpeningAct.send(:remove_files, 'spec')

    OpeningAct.send(:rename_template_files)
    assert_equal 1, Dir.glob('bubbles').length
    assert_equal 0, Dir.glob('bubbles/*_*').length
    assert_equal 1, Dir.glob('bubbles/test').length
    assert_equal 1, Dir.glob('bubbles/Gemfile').length
    assert_equal 1, Dir.glob('bubbles/Rakefile').length
    assert_equal 1, Dir.glob('bubbles/bubbles.rb').length
  end

  def teardown
    FileUtils.rm_rf('bubbles')
    $stdout = STDOUT
    $stdin = STDIN
  end
end
