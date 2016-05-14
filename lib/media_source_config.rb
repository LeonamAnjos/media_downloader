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

end