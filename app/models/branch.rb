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

  def schedules
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
    timetables = {}
    schedules.each_with_index do |schedule, index_1|
      date = {}
      schedule.css('.sch-row').each do |row|
        date[:day] = row.css('p').text
        times = {}
        row.css('.normaltools').each_with_index do |time, index_2|
          times[index_2 + 1] = time.text
        end
        date[:times] = times
      end
      timetables[index_1 + 1] = date
      @elements[index_1][:schedules] = timetables
    end
  end

end
