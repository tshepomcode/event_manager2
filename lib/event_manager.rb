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
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'
require 'time'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
    # legislators = legislators.officials
    # legislator_names = legislators.map(&:name)
    # legislator_names.join(", ")
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def clean_homephone(homephone)
  homephone.gsub!(/\D/, '')
  homephone.gsub!(/\s+/, '')

  if homephone.length > 10 && homephone.chr == '1'
    homephone.delete_prefix!(homephone.chr)
  elsif homephone.length > 10 || homephone.length < 10
    homephone.replace '0000000000'
  end
  
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def save_hours(regdate, reg_hours)
  reg_date = Time.strptime(regdate, "%m/%d/%y %H:%M")
  reg_hours << reg_date.hour
end

def display_peak_hours(reg_hours)
  reg_peak = Hash.new(0)
  reg_hours.each {|hour| reg_peak[hour] += 1}

  peak_hours = reg_peak.sort_by { |hour, peak| peak}.last(2).flatten!
  a, b = peak_hours.values_at(0, 2)
  puts "Peak hours at #{a} and #{b}"
end

def save_weekdays(regdate, week_days)

  reg_date = Date.strptime(regdate, "%m/%d/%y")
  # week_days << reg_date.wday
  week_days << reg_date.strftime("%A")
end

puts 'EventManager Initialized!'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter
reg_hours = []
week_days = []

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  homephone = row[:homephone]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  clean_homephone(homephone)

  save_hours(row[:regdate], reg_hours)

  #save week days

  save_weekdays(row[:regdate], week_days)
  # reg_date = Date.strptime(row[:regdate], "%m/%d/%y")
  # # week_days << reg_date.wday
  # week_days << reg_date.strftime("%A")
  
  

  # puts reg_date.wday
 
  # form_letter = erb_template.result(binding)

  # save_thank_you_letter(id, form_letter)

end

# display_peak_hours(reg_hours)
display peek_day(week_days)

wday_peak = Hash.new(0)
week_days.each {|wday| wday_peak[wday] += 1}

puts "Week days"
p wday_peak

peak_days = wday_peak.sort_by { |wday, peak| peak}.last[0]

puts "Peak Days"
puts peak_days

# reg_peak = Hash.new(0)
#   reg_hours.each {|hour| reg_peak[hour] += 1}

#   peak_hours = reg_peak.sort_by { |hour, peak| peak}.last(2).flatten!
#   a, b = peak_hours.values_at(0, 2)
#   puts "Peak hours at #{a} and #{b}"