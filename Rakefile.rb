require 'resque/tasks'

task 'resque:setup' do
  require './environment'
  require 'content_loader_job'
end