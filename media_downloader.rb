require './environment'
require 'jobs/enqueue_medias_job'
require 'jobs/content_loader_job'


# Task one: enqueue media files from web source
puts EnqueueMediasJob.perform

# Task two: download media files and add content to MEDIA_XML list
#-> ContentLoaderJob.perform(media_file): resque job execute this method

