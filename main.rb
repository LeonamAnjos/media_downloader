$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'ruby-prof'
require 'http_downloader'
require 'media_source'
require 'media_source_config'

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

RubyProf.start

get_medias.each do |m|
  download_media url: config.media_source,
                 download_path: config.download_path,
                 file_name: m
end

result = RubyProf.stop

# print a flat profile to text
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
