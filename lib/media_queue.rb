require 'redis'

class MediaQueue
  attr_reader :redis
  attr_reader :config

  def initialize(media_source_config, redis_instance)
    @config = media_source_config
    @redis = redis_instance
  end

  def enqueue(source)
    source.media_files.each do  |media|
      enqueue_media(media)
    end
  end

  def dequeue
    redis.lpop queue_name
  end

  def size
    redis.llen queue_name
  end

  def set_processed(media_file)
    redis.set LAST_MEDIA_PROCESSED_KEY, media_file
    redis.srem queue_idx, media_file
  end

  private

  LAST_MEDIA_PROCESSED_KEY = 'NEWS_XML_LAST_PROCESSED'

  def enqueue_media(media)
    return if processed? media

    if redis.sadd(queue_idx, media)
      redis.rpush(queue_name, media)
    end
  end

  def processed?(media)
    media <= last_media_processed
  end

  def queue_name
    @queue_name ||= config.media_content_list + '_QUEUE'
  end

  def queue_idx
    @queue_idx ||= queue_name + '_IDX'
  end

  def last_media_processed
    redis.get(LAST_MEDIA_PROCESSED_KEY) || ''
  end

end
