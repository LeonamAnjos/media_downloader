require 'redis'
require './lib/media_source_config'

class MediaQueue
  attr_reader :redis
  attr_reader :config

  def initialize
    @config = MediaSourceConfig.new
    @redis = Redis.new
  end

  def enqueue(source)
    source.media_files.each do  |media|
      enqueue_media(media)
    end
  end

  def size
    redis.llen queue_name
  end

  def queue_name
    @queue_name ||= config.media_content_list + '_QUEUE'
  end

  def queue_idx
    @queue_idx ||= queue_name + '_IDX'
  end

  def last_media_processed
    redis.get('NEWS_XML_LAST_PROCESSED') || ''
  end

  private

  def enqueue_media(media)
    return if processed? media

    if redis.sadd(queue_idx, media)
      redis.rpush(queue_name, media)
    end
  end

  def processed?(media)
    media <= last_media_processed
  end

end
