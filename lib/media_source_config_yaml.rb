require 'media_source_config'

class MediaSourceConfigYaml
  include MediaSourceConfig

  def initialize(config_file = 'config.yml')
    @config = File.exists?(config_file) ? YAML.load_file(config_file) : {}
  end
end