# coding: utf-8
require 'test/unit'
require 'mocha/test_unit'
require 'media_source_config_yaml'

class MediaSourceConfigYamlTest < Test::Unit::TestCase

  attr_reader :subject
  attr_reader :config_file

  def setup
    @config_file = 'test_config.yaml'
    @config_content = {
        'media_source' => 'http://test/media/source/',
        'download_path' => '/tmp/downloads/',
        'media_extension_name' => '*.xml',
        'media_content_list' => 'NEWS_XML'
    }

    File.expects(:exists?).with(config_file).returns(true)
    YAML.expects(:load_file).with(config_file).returns(@config_content)

    @subject = MediaSourceConfigYaml.new(config_file)
  end

  test 'should not raise error if config file is not found' do
    File.expects(:exists?).with(config_file).returns(false)

    media_config = MediaSourceConfigYaml.new(config_file)
    assert_nil(media_config.media_source)
  end

  test 'should return media source' do
    assert_equal('http://test/media/source/', subject.media_source)
  end

  test 'should return download path' do
    assert_equal('/tmp/downloads/', subject.download_path)
  end

  test 'should return media extension' do
    assert_equal('*.xml', subject.media_extension)
  end

  test 'should return media content list' do
    assert_equal('NEWS_XML', subject.media_content_list)
  end

end