# coding: utf-8
require 'redis'
require 'media_queue'
require 'http_downloader'
require 'media_content_loader'
require 'media_source_config_yaml'

class ContentLoaderJob
  @queue = :news_xml

  def self.perform(media_file)
    ContentLoaderJob.for(media_file).load_media_content
  end

  def self.for(media_file)
    ContentLoaderJob.new(media_file)
  end

  def load_media_content
      download_file_and_load_content
      media_queue.set_processed(media_file)
  end

  private

  attr_reader :media_file
  attr_reader :config
  attr_reader :redis
  attr_reader :media_queue
  attr_reader :downloader

  def initialize(media_file)
    @media_file = media_file
    @config = MediaSourceConfigYaml.new
    @redis = Redis.new
    @media_queue = MediaQueue.new(config, redis)
    @downloader = HttpDownloader.new(url: config.media_source, download_path: config.download_path)
  end

  def download_file_and_load_content
    downloader.download_file(media_file)

    MediaContentLoader.each_media_content(pattern) do |content|
      redis.rpush(config.media_content_list, content)
    end

    FileUtils.rm_rf(config.download_path + media_file)
  end

  def pattern
    config.download_path + media_file + '/*' + config.media_extension
  end

end