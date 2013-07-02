require 'dbd'

# load all factories
root = File.expand_path('../', __FILE__)
Dir[root + "/factories/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.order = 'random'

  # exclude neo4j tests for now (not working on Travis)
  config.filter_run_excluding :neo4j => true
  config.filter_run_excluding :neo4j_performance => true
end
