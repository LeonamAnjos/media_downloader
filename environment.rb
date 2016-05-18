# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
jobs = File.expand_path('../jobs', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$LOAD_PATH.unshift(jobs) unless $LOAD_PATH.include?(jobs)