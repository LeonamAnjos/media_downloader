# coding: utf-8
require 'resque/tasks'

task 'resque:setup' do
  require_relative 'environment'
  require 'content_loader_job'
end