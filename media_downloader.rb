# coding: utf-8
require_relative 'environment'
require 'enqueue_medias_job'
require 'daemons'

def config_file
  config_arg = ARGV.select { |v| /^--config/.match(v) }.first
  if config_arg.nil?
    config = 'config.yml'
  else
    config = config_arg.split('=').last
  end

  File.expand_path(config)
end

job = EnqueueMediasJob.new(config_file)

# Task one: enqueue media files from web source
Daemons.run_proc('enqueue_medias_job') do
  loop do
    puts 'EnqueueMediasJob - start'

    medias_enqueued = job.do

    puts "EnqueueMediasJob - more #{medias_enqueued} enqueued"

    puts 'EnqueueMediasJob - sleeping for 60 seconds'
    sleep(60)
    puts 'EnqueueMediasJob - finished'
  end

end
