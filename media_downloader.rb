# coding: utf-8
require_relative 'environment'
require 'enqueue_medias_job'
require 'daemons'
require 'logger'

def config_file
  config_arg = ARGV.select { |v| /^--config/.match(v) }.first
  if config_arg.nil?
    config = 'config.yml'
  else
    config = config_arg.split('=').last
  end

  File.expand_path(config)
end

$LOG = Logger.new('media_downloader.log', 10, 'daily')
job = EnqueueMediasJob.new(config_file)


# Task one: enqueue media files from web source
Daemons.run_proc('enqueue_medias_job') do
  loop do
    begin
      $LOG.info('EnqueueMediasJob') { 'Start' }

      medias_enqueued = job.do

      $LOG.info('EnqueueMediasJob') { "More #{medias_enqueued} enqueued. Sleeping for 60 seconds..." }
      sleep(60)
      $LOG.info('EnqueueMediasJob') { 'Finish' }
    rescue Exception => e
      $LOG.error('EnqueueMediasJob') { e.message }
      $LOG.error('EnqueueMediasJob') { e.backtrace.inspect }
      $LOG.info('EnqueueMediasJob') { 'Waiting 3 minutes before trying again.' }
      sleep(3 * 60)
    end
  end

end
