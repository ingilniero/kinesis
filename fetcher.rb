require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

cinemex = open('http://cinemex.com/cines/151')
doc = Nokogiri::HTML(cinemex.read)
doc.encoding = 'utf-8'

movies_hash = {}
movies = doc.css('.cinema')

elements = []
movies.count.times do |n|
  elements[n] = {}
end

movies.each_with_index do |movie, index|
  elements[index][:name] = movie.text
end

types = doc.css('.type')
counter = 0
types.each_with_index do |type, index|
  if index.even?
    elements[counter][:clasification] = type.text
  else
    elements[counter][:language] = type.text
    counter += 1
  end
end

movie_images = doc.css('.img-cont a img')

movie_images.each_with_index do |image, index|
  elements[index][:image_url] = image.attributes['src'].value
end


schedules = doc.css('.block')

timetables = {}
schedules.each_with_index do |schedule, index_1|
  date = {}
  schedule.css('.sch-row').each do |row|
    date[:day] = row.css('p').text
    times = {}
    row.css('.normaltools').each_with_index do |time, index_3|
      times[index_3 + 1] = time.text
    end
    date[:times] = times
  end
  timetables[index_1 + 1] = date
  elements[index_1][:schedules] = timetables
end

elements.each_with_index do |element, index|
  movies_hash[index + 1] = element
end
puts movies_hash.to_json
