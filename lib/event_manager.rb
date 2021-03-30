# puts 'EventManager Initialized!'

# # read the entire contents of a file
# contents = File.read('event_attendees.csv')
# puts contents

# lines = File.readlines('event_attendees.csv')
# lines.each do |line|
#   # puts line
#   columns = line.split(",")
#   # p columns
#   name = columns[2]
#   puts name
# end

## Using the CSV Library
require 'csv'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

puts 'EventManager Initialized!'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
contents.each do |row|
  name = row[:first_name]
  homephone = row[:homephone]

  zipcode = clean_zipcode(row[:zipcode])

  puts "#{name} #{zipcode}"
end
