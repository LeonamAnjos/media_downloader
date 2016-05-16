require 'resque'

class MediaQueue
  attr_reader :redis
  attr_reader :config

  def initialize(media_source_config, redis_instance)
    @config = media_source_config
    @redis = redis_instance
  end

  def enqueue(media)
    return false if processed? media
    return false unless redis.sadd(queue_idx, media)

    Resque.enqueue(ContentLoaderJob, media)
  end

  def set_processed(media)
    redis.set LAST_MEDIA_PROCESSED_KEY, media
    redis.srem queue_idx, media
  end

  private

  LAST_MEDIA_PROCESSED_KEY = 'NEWS_XML_LAST_PROCESSED'

  def processed?(media)
    media <= last_media_processed
  end

  def last_media_processed
    redis.get(LAST_MEDIA_PROCESSED_KEY) || ''
  end

  def queue_idx
    @queue_idx ||= config.media_content_list + '_IDX'
  end

end
