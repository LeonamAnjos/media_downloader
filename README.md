#Media Downloader



$ rake resque:work QUEUE=news_xml --trace
$ rake resque:workers QUEUE=news_xml COUNT=5 --trace

127.0.0.1:6379> llen resque:queue:news_xml
127.0.0.1:6379> llen NEWS_XML
127.0.0.1:6379> get NEWS_XML_LAST_PROCESSED