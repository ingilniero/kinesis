require 'nokogiri'
require 'open-uri'
require 'json'

class Branch
  def initialize(params = {})
    @id = params[:id]
    @elements = []
    @movies_hash = {}
  end

  def get_json
    init
    get_names
    get_types
    get_images
    get_schedules
    set_elements
    @movies_hash
  end

  private
  def url
    open("http://cinemex.com/cines/#{@id}")
  end

  def init
    @doc = Nokogiri::HTML(url.read)
    @doc.encoding = 'utf-8'

    movies.count.times do |i|
      @elements[i] = {}
    end
  end

  def set_elements
    @elements.each_with_index do |element, index|
       @movies_hash[index + 1] = element
     end
  end

  def movies
    @doc.css('.cinema')
  end

  def types
    @doc.css('.type')
  end

  def movies_images
    @doc.css('.img-cont a img')
  end

  def movies_schedules
    @doc.css('.block')
  end

  def get_names
    movies.each_with_index do |movie, index|
      @elements[index][:name] = movie.text
    end
  end

  def get_types
    counter = 0
    types.each_with_index do |type, index|
      if index.even?
        @elements[counter][:clasification] = type.text
      else
        @elements[counter][:language] = type.text
        counter += 1
      end
    end
  end

  def get_images
    movies_images.each_with_index do |image, index|
      @elements[index][:image_url] = image.attributes['src'].value
    end
  end

  def get_schedules
    movies_schedules.each_with_index do |movie, index_1|

      count = 1
      dates = {}
      movie.css('p').each_with_index do |day, index_2|
        date = {}
        if index_2.even?
          date[:day] = day.text
          dates[count] = date
          count += 1
        end
      end

      firsts = movie.at_css('.sch-row').css('a')
      times = {}

      firsts.each_with_index do |a, index|
        times[index + 1] = a.text
      end

      dates[1][:times] = times

      times2 = {}

      count2 = 1
      movie.css('.normaltools').each_with_index do |time, index_3|
        if index_3 >= firsts.length
          times2[count2] = time.text
          count2 += 1
        end
      end

      if dates[2]
        dates[2][:times] = times2
      end

      @elements[index_1][:schedules] = dates
    end
  end

end
