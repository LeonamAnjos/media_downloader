# coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'media_source'

class MediaHttpSource
  include MediaSource

  attr_reader :uri

  def initialize(uri)
    @uri = URI(uri)
    parse_medias Nokogiri::HTML(open(uri))
  end

  private

  def parse_medias(html_doc)
    @media_files = html_doc.xpath('//tr//td//a').map do |e|
      e.text if e.text.downcase.include? '.zip'
    end

    @media_files.compact!
  end
end
