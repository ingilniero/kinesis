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

  def get_days(movie)
    count = 1
    movie.css('p').each_with_index do |day, index_2|
      date = {}
      if index_2.even?
        date[:day] = day.text
        @dates[count] = date
        count += 1
      end
    end
  end

  def get_first_times(movie)
    times = {}
    firsts = movie.at_css('.sch-row').css('a')

    firsts.each_with_index do |a, index|
      times[index + 1] = a.text
    end

    @dates[1][:times] = times
  end

  def get_second_times(movie, length)
    times = {}
    count = 1
    movie.css('.normaltools').each_with_index do |time, index|
      if index >= length
        times[count] = time.text
        count += 1
      end
    end
    @dates[2][:times] = times
  end

  def get_schedules
    movies_schedules.each_with_index do |movie, index|
      @dates = {}

      get_days(movie)
      length =  get_first_times(movie).length
      get_second_times(movie, length) if @dates[2]

      @elements[index][:schedules] = @dates
    end
  end

end
