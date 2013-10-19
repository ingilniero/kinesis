require 'nokogiri'
require 'open-uri'

class Movie
  def initialize(id)
    @id = id
    @movie = {}
  end

  def get_json
    init
    get_title
    get_image
    get_info
    get_synopsis
    @movie
  end

  private

  def url
    open("http://cinemex.com/cartelera/pelicula/#{19189}")
  end

  def init
    @doc = Nokogiri::HTML(url.read)
    @doc.encoding = 'utf-8'
  end

  def title
    @doc.css('#title')
  end

  def image
    @doc.at_css('#poster img')
  end

  def info
    @doc.css('#info')
  end

  def synopsis
    @doc.at_css('#story p')
  end

  def get_title
    @movie[:title] = title.text
  end

  def get_image
    @movie[:image_url] = image['src']
  end

  def get_info
   metadata = %i{ director actors gender clasification time year }
   info.css('p').each_with_index do |p, index|
     @movie[metadata[index]] = p.text.split(':').last.strip
   end
  end

  def get_synopsis
    @movie[:synopsis] = synopsis.text
  end
end
