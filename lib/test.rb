reg_hours =  [10, 13, 13, 19, 11, 15, 16, 17, 1, 16, 18, 21, 11, 13, 20, 19, 21, 16, 20]

# puts reg_hours

reg_peak = Hash.new(0)
reg_hours.each {|hour| reg_peak[hour] += 1}

# puts 'Peak hours'
# # p reg_peak

peak_hours = reg_peak.sort_by { |hour, peak| peak}.last(2)
# p peak_hours[0][0]
# p peak_hours[1][0]
