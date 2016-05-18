# coding: utf-8
require 'redis'
require 'media_queue'
require 'media_source_config_yaml'
require 'media_http_source'

class EnqueueMediasJob

  attr_reader :config
  attr_reader :media_queue

  def self.perform

    loop do

      puts 'EnqueueMediasJob - start'

      count = 0
      task.media_source.media_files.each do  |media|
        count += 1 if task.media_queue.enqueue(media)
      end

      puts "EnqueueMediasJob - more #{count} enqueued"

      puts 'EnqueueMediasJob - sleeping for 60 seconds'
      sleep(60)

      puts 'EnqueueMediasJob - finished'

    end
  end

  def media_source
    MediaHttpSource.new(config.media_source)
  end

  private

  def self.task
    @@task ||= EnqueueMediasJob.new
  end

  def initialize
    @config = MediaSourceConfigYaml.new
    @media_queue = MediaQueue.new(config, Redis.new)
  end

end