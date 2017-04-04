require 'test_helper'
require 'fileutils'

class OpeningActTest < Minitest::Test
  def setup
    $stdout = StringIO.new
    $stdin = StringIO.new('\n')
  end

  def test_that_it_has_a_version_number
    refute_nil OpeningAct::VERSION
  end

  def test_opening_act_setup_success
    OpeningAct.perform('bubbles', '-minitest')
    assert $stdout.string.match(/this command will initiate a git project./)
    refute $stdout.string.match(/The Opening Act was forced to leave the stage early./)
    refute $stdout.string.match(/The Opening Act has performed./)
  end

  def test_opening_act_setup_halt
    $stdin = StringIO.new('halt')
    OpeningAct.perform('bubbles', '-minitest')
    assert $stdout.string.match(/this command will initiate a git project./)
    assert $stdout.string.match(/The Opening Act was forced to leave the stage early./)
    refute $stdout.string.match(/The Opening Act has performed./)
  end

  def test_opening_act_success_minitest
    OpeningAct.perform('bubbles', '-minitest')
    assert $stdout.string.match(/this command will initiate a git project./)
    assert $stdout.string.match(/The Opening Act has performed./)
  end

  def test_opening_act_success_rspec
    OpeningAct.perform('bubbles', '-rspec')
    assert $stdout.string.match(/this command will initiate a git project./)
    assert $stdout.string.match(/The Opening Act has performed./)
  end

  def teardown
    FileUtils.rm_rf('bubbles')
    $stdout = STDOUT
    $stdin = STDIN
  end
end
