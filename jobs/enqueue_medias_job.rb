# coding: utf-8
require 'redis'
require 'media_queue'
require 'media_source_config_yaml'
require 'media_http_source'

class EnqueueMediasJob

  attr_reader :config
  attr_reader :media_queue

  def initialize(config_file)
    @config = MediaSourceConfigYaml.new(config_file)
    @media_queue = MediaQueue.new(config, Redis.new)
  end

  def do
    count = 0
    media_source.media_files.each do  |media|
      count += 1 if media_queue.enqueue(media)
    end
    count
  end

  def media_source
    MediaHttpSource.new(config.media_source)
  end

end