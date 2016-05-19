# coding: utf-8
require 'resque'
require 'content_loader_job'

class MediaQueue

  LAST_MEDIA_PROCESSED_KEY = 'NEWS_XML_LAST_PROCESSED'
  
  attr_reader :redis
  attr_reader :config

  def initialize(media_source_config, redis_instance)
    @config = media_source_config
    @redis = redis_instance
  end

  def enqueue(media)
    return false if processed? media
    return false unless enqueued?(media)

    Resque.enqueue(ContentLoaderJob, media)
  end

  def set_processed(media)
    redis.set LAST_MEDIA_PROCESSED_KEY, media
    redis.srem queue_idx, media
  end

  private

  def processed?(media)
    media <= last_media_processed
  end

  def last_media_processed
    redis.get(LAST_MEDIA_PROCESSED_KEY) || ''
  end

  def queue_idx
    @queue_idx ||= config.media_content_list + '_IDX'
  end

  def enqueued?(media)
    redis.sadd(queue_idx, media)
  end

end
