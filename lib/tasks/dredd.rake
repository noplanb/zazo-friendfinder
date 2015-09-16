require 'dredd/rack'

Dredd::Rack::RakeTask.new do |task|
  task.runner.configure do |runner|
    runner.api_endpoint Figaro.env.api_endpoint if Figaro.env.api_endpoint?
    runner.paths_to_blueprints 'apiary.apib', 'doc/*.apib doc/*.apib.md'
  end
end
