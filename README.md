# Media Downloader

### Introduction

__NUVI__ is a Social Media Analytics company. Part of our business is aggregating data from various data sources. Your project is to write a software application that aggregates news data and publishes it to Redis.

### Getting Started

This URL (http://bitly.com/nuvi-plz) is an http folder containing a list of zip files. Each zip file contains a bunch of xml files. Each xml file contains 1 news report.

Your application needs to download all of the zip files, extract out the xml files, and publish the content of each xml file to a redis list called “NEWS_XML”.

Make the application idempotent. We want to be able to run it multiple times but not get duplicate data in the redis list.

### Solution

The application is composed of two jobs:
- ___EnqueueMediasJob___ - get the list of media files available at the HTTP resource and enqueue for download.
- ___ContentLoaderJob___ - download a media file, extract out the xml files and publish the content of each xml file to "NEWS_XML" redis list.

### Installation

Media Downloader requires [Redis] (http://redis.io/) running with default configuration.
You can download _Media Downloader_ project from [GitHub] (https://github.com/LeonamAnjos/media_downloader) or clone it with following command:

```sh
$ git clone https://github.com/LeonamAnjos/media_downloader.git
$ cd media_downloader
```
It is necessary to install some _"gems"_ listed in the Gemfile. You can use _bundler_ to do the task.
```sh
$ bundle install
```

### Configuration
The application needs some environment information to perform. You can do it by editing _"config.yml"_. There you can set:
- ___media_source___ - the http resource URL.
- ___download_path___ - folder with read/write permission
- ___media_extension_name___ - the extension of media files content
- ___media_content_list___ - the key for the redis list of contents

### Running

To run the job ___EnqueueMediasJob___:
```sh
$ ruby media_downloader.rb
```

To load one instance of the job ___ContentLoaderJob___:
```sh
$ rake resque:work QUEUE=news_xml --trace
```
To load more then one instance of the job ___ContentLoaderJob___ at the same sation:
```sh
$ rake resque:workers QUEUE=news_xml COUNT=3 --trace
```
You can monitor the queue and the content stored by redis-cli:
```sh
$ redis-cli
127.0.0.1:6379> llen resque:queue:news_xml
127.0.0.1:6379> llen NEWS_XML
127.0.0.1:6379> get NEWS_XML_LAST_PROCESSED
```
or even better: using resque-web. After running the commando below, go to your web browser and open _http://localhost:5678/overview_:
```sh
$ resque-web
```


### TO-DO
- Allow to inform redis connection configuration
- Execute ___EnqueueMediasJob___ in background (maybe using Daemons gem)
- Tests
- Logging
