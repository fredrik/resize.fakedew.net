RSpec.configure do |config|
  ENV['RACK_ENV'] = 'test'

  # app specific test environment
  ENV['DATABASE_URL'] = 'postgres://localhost/resize_test'
  ENV['RESIZE_DATA_PATH'] = '/tmp/resize_test'
  ENV['MAILGUN_USER'] = 'api'
  ENV['MAILGUN_PASSWORD'] = 'xyz'

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
end
