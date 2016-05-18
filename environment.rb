# coding: utf-8
[   File.expand_path('..', __FILE__),
    File.expand_path('../lib', __FILE__),
    File.expand_path('../jobs', __FILE__)].each do |path|
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end
