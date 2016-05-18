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

config = config_file


# Task one: enqueue media files from web source
Daemons.run_proc('enqueue_medias_job') do
  EnqueueMediasJob.perform(config)
end

# Task two: download media files and add content to MEDIA_XML list
#-> ContentLoaderJob.perform(media_file): resque job execute this method

