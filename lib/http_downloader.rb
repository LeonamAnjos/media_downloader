require 'cocoapods-downloader'

class HttpDownloader

  def initialize(args = {})
    @url = args[:url]
    @download_path = args[:download_path]
  end

  def download_file(file_name)
    raise 'Invalid file name!' if file_name.nil?

    downloader = Pod::Downloader.for_target(
        target_path(file_name),
        { http: http_file_reference(file_name) })
    downloader.download
  end


private

  def target_path(file_name)
    @download_path + file_name
  end

  def http_file_reference(file_name)
    @url + file_name
  end

end
