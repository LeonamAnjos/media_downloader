require 'yaml'

class MediaSourceConfig

  def initialize(config_file = 'config.yml')
    @config = File.exists?(config_file) ? YAML.load_file(config_file) : {}
  end

  def media_source
    @config['media_source']
  end

  def download_path
    @config['download_path']
  end

  def media_extension
    @config['media_extension_name']
  end

  def media_content_list
    @config['media_content_list']
  end

end