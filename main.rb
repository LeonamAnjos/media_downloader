$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'http_downloader'

options = { url: 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/',
            downloads_path: '/tmp/nuvi/' }

downloader = HttpDownloader.new(options)
downloader.download_file('1462892381349.zip')