class Template
  attr_reader :test_type
  attr_accessor :name

  PROJECT_TEMPLATE = File.expand_path('../templates', __FILE__)

  def initialize(name, type)
    @name = name
    @test_type = type[1..-1]
  end

  def create
    FileUtils.copy_entry PROJECT_TEMPLATE, name
  end

  def initiate_project
    Dir.chdir name do
      `git init`
      `bundle install`
    end
  end

  def rename_files
    File.rename("#{name}/new_app.rb", "#{name}/#{name}.rb")

    case (test_type)
    when 'minitest'
      File.rename("#{name}/test/new_app_test.rb", "#{name}/test/#{name}_test.rb")
    when 'rspec'
      File.rename("#{name}/spec/new_app_spec.rb", "#{name}/spec/#{name}_spec.rb")
    end

    remove_test_suffix
  end

  def remove_extra_files
    other_test_type = test_type == 'rspec' ? 'test' : 'spec'

    FileUtils.rm_rf("#{name}/#{other_test_type}")
    FileUtils.rm Dir.glob("#{name}/*_#{other_test_type}")
  end

  private

  def remove_test_suffix
    Dir.glob("#{name}/*_*").each do |file|
      File.rename(file, file[0..-6])
    end
  end
end
