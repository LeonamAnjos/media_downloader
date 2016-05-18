# coding: utf-8
require 'test/unit'
require 'mocha/test_unit'
require 'media_queue'
require 'content_loader_job'

class MediaQueueTest < Test::Unit::TestCase

  attr_reader :config
  attr_reader :redis
  attr_reader :media
  attr_reader :subject

  LAST_PROCESSED_KEY = 'NEWS_XML_LAST_PROCESSED'

  def setup
    @config = mock()
    @redis = mock()
    @media = '111112.zip'

    @subject = MediaQueue.new(config, redis)
  end

  test 'should not enqueue media with same name as the last processed one' do
    redis.expects(:get).with(LAST_PROCESSED_KEY).returns('111112.zip')
    assert_false(subject.enqueue media)
  end

  test 'should not enqueue media if media file name is smaller than the last processed one' do
    redis.expects(:get).with(LAST_PROCESSED_KEY).returns('111113.zip')
    assert_false(subject.enqueue media)
  end

  test 'should not enqueue media if it is already enqueued' do
    config.expects(:media_content_list).returns('NEWS_XML')
    redis.expects(:get).with(LAST_PROCESSED_KEY).returns('111111.zip')
    redis.expects(:sadd).with(instance_of(String), media).returns(false)

    assert_false(subject.enqueue media)
  end

  test 'should enqueue media' do
    config.expects(:media_content_list).returns('NEWS_XML')
    redis.expects(:get).with(LAST_PROCESSED_KEY).returns('111111.zip')
    redis.expects(:sadd).with(instance_of(String), media).returns(true)

    Resque.expects(:enqueue).with(is_a(Class), media).returns(true)

    assert_true(subject.enqueue media)
  end


end