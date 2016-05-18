# coding: utf-8
require 'resque/tasks'
require 'rake/testtask'

task 'resque:setup' do
  require_relative 'environment'
  require 'content_loader_job'
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
