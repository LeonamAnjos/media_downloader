require './enqueue_medias_task'
require './content_loader_task'


# Task one: enqueue media files from web source
puts EnqueueMediasTask.perform

# Task two: download media files and add content to MEDIA_XML list
puts ContentLoaderTask.perform
