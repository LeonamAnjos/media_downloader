require 'nokogiri'
require 'open-uri'

class MediaSource
  attr_reader :uri
  attr_reader :media_files

  def initialize(uri)
    puts "uri: #{uri}"
    @uri = URI(uri)
  end

  def update_medias
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
