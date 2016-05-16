require 'redis'
require './lib/media_source_config_yaml'
require './lib/media_http_source'
require './lib/media_queue'

class EnqueueMediasTask

  attr_reader :config
  attr_reader :media_queue

  def self.perform
    task.media_queue.enqueue(task.media_source)
    task.media_queue.size
  end

  def media_source
    MediaHttpSource.new(config.media_source)
  end

  private

  def self.task
    @@task ||= EnqueueMediasTask.new
  end

  def initialize
    @config = MediaSourceConfigYaml.new
    @media_queue = MediaQueue.new(config, Redis.new)
  end

end