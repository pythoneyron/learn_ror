puts "Как тебя зовут?"
name = gets.chomp

puts "В каком году ты родился?"
year = gets.chomp

puts "#{name}, привет! Тебе #{2021 - year.to_i} лет. Ты слишком старый!"
