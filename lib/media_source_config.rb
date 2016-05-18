# coding: utf-8
require 'yaml'

module MediaSourceConfig

  def config
    @config || {}
  end

  def media_source
    config['media_source']
  end

  def download_path
    config['download_path']
  end

  def media_extension
    config['media_extension_name']
  end

  def media_content_list
    config['media_content_list']
  end
end
