$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'ruby-prof'
require 'http_downloader'
require 'media_source'

def download_media(args = {})
  url = args[:url] || 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/'
  path = args[:download_path] || '/tmp/nuvi/'

  options = { url: url,
              downloads_path: path }

  downloader = HttpDownloader.new(options)
  downloader.download_file(args[:file_name])
end

def get_medias
  ms = MediaSource.new('http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/')
  ms.update_medias
end

RubyProf.start

get_medias.each do |m|
  download_media url: 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/',
                 download_path: '/tmp/nuvi/',
                 file_name: m
end

result = RubyProf.stop

# print a flat profile to text
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
