# coding: utf-8
module MediaContentLoader

  def MediaContentLoader.each_media_content(pattern = '')
    Dir.glob(pattern) do |file_name|
      content = content_from(file_name)
      yield(content) if block_given?
    end
  end

  def MediaContentLoader.content_from(file_name)
    content = ''
    File.open(file_name) do |file|
      while line = file.gets
        content << line
      end
    end
    content
  end

end

