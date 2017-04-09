module Verifiable
  def valid_characters?(project_name)
    !%r{[\#%&{}\\<>*?\/ $!'":@+`|=]}.match(project_name)
  end

  def valid_initial_character?(project_name)
    !/[ .\-_]/.match(project_name[0])
  end

  def valid_name?(project_name)
    !project_name.nil? &&
      valid_characters?(project_name) &&
      valid_initial_character?(project_name) &&
      project_name.length < 31
  end

  def valid_test?(test_type)
    !test_type.nil? && correct_test_name?(test_type) && flag?(test_type)
  end
end
