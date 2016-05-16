require 'redis'
require './lib/http_downloader'
require './lib/media_content_loader'

class ContentLoaderTask

  def self.perform
    task = ContentLoaderTask.new
    task.load_media_content
  end

  def load_media_content
    while media_queue.size > 0
      media_file = media_queue.dequeue
      download_file_and_load_content(media_file)
      media_queue.set_processed(media_file)
    end
  end

  private

  attr_reader :config
  attr_reader :redis
  attr_reader :media_queue
  attr_reader :downloader

  def initialize
    @config = MediaSourceConfigYaml.new
    @redis = Redis.new
    @media_queue = MediaQueue.new(config, redis)
    @downloader = HttpDownloader.new(url: config.media_source, download_path: config.download_path)
  end

  def get_pattern(media_file)
    config.download_path + media_file + '/*' + config.media_extension
  end

  def download_file_and_load_content(media_file)
    downloader.download_file(media_file)

    MediaContentLoader.each_by_pattern(get_pattern(media_file)) do |content|
      redis.rpush(config.media_content_list, content)
    end

    FileUtils.rm_rf(config.download_path + media_file)
  end

end
