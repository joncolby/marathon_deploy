require_relative 'test_helper'

class ApplicationTest < Minitest::Test
  
  def setup
    $LOG = Logger.new(STDOUT)
    $LOG.level = Logger::INFO
    @release_version = "TEST_VERSION_#{Time.now.utc.iso8601}"
    ENV['RELEASE_VERSION'] = @release_version
    @json = File.expand_path('../fixtures/deploy.json',__FILE__)
    @yml = File.expand_path('../fixtures/deploy.yml',__FILE__)
  end
  
  def test_new_application_with_json
    application = MarathonDeploy::Application.new(:deployfile => @json)
    assert_instance_of(MarathonDeploy::Application,application)
    refute_empty(application.id)
    application.add_envs({ :MINITEST => "MINITEST_ENV_TEST" })
    assert_equal("MINITEST_ENV_TEST",application.env[:MINITEST])
    application.add_envs({ :INTIGERTEST => 5 })
    assert_equal("5",application.env[:INTIGERTEST])
    application.add_envs({ :PITEST => 3.14159 })
    assert_equal("3.14159",application.env[:PITEST])
  end
  
  def test_new_application_with_yaml
    application = MarathonDeploy::Application.new(:deployfile => @yml)
    assert_instance_of(MarathonDeploy::Application,application)
    refute_empty(application.id)
    assert_equal(@release_version,application.env[:RELEASE_VERSION])
  end
  
  def test_force_new_application
    app = MarathonDeploy::Application.new(:deployfile => @yml, :force => true)
    unique_id = app.env['UNIQUE_ID']
    msg = "UNIQUE_ID environment variable was not set properly"
    refute_nil(unique_id,msg)
    refute_empty(unique_id,msg)
  end
  
  def test_health_checks_defined
    app = MarathonDeploy::Application.new(:deployfile => @yml)
    refute_nil(app.health_checks, "health checks returned nil")    
    refute_empty(app.health_checks, "health checks returned empty")
  end
  
end
