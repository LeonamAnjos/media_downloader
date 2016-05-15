#$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'ruby-prof'
require './lib/http_downloader'
require './lib/media_source'
require './lib/media_source_config'
require './lib/loader_content'
require 'redis'

def config
  @config ||= MediaSourceConfig.new
end

def download_media(args = {})
  url = args[:url]
  path = args[:download_path]

  options = { url: url,
              downloads_path: path }

  downloader = HttpDownloader.new(options)
  downloader.download_file(args[:file_name])
end

def get_medias
  ms = MediaSource.new(config.media_source)
  ms.update_medias
end

def get_pattern(media_file)
  config.download_path + media_file + '/*' + config.media_extension
end

RubyProf.start

redis = Redis.new

get_medias.each do |media_file|
  download_media url: config.media_source,
                 download_path: config.download_path,
                 file_name: media_file

  LoaderContent.each_by_pattern(get_pattern(media_file)) do |content|
    redis.rpush('NEWS_XML', content)
  end

  FileUtils.rm_rf(config.download_path + media_file)

end



result = RubyProf.stop

# print a flat profile to text
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)


# mq = MediaQueue.new
# puts mq.queue_name
# puts mq.queue_idx
# mq.enqueue
# puts mq.size


# call loader if queue.count > 0
