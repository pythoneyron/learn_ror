=begin
Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
=end

while true
  puts 'Введите дату!'

  print 'Число: '
  date = gets.chomp.to_i

  print 'Месяц: '
  month = gets.chomp.to_i

  print 'Год: '
  year = gets.chomp.to_i

  puts date

  if month > 12 || month <= 0 || date > 31 || date <= 0 || year.digits.length != 4 || year <= 0
    puts 'Введенные вами числа не корректные, повторите ввод!'
  else
    break
  end
end

months = {
  1 => 31,
  2 => 28,
  3 => 31,
  4 => 30,
  5 => 31,
  6 => 30,
  7 => 31,
  8 => 31,
  9 => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

if year % 4 == 0 || (year % 100 != 0 && year % 400 == 0)
  months[2] = 29
end

days = months.map { |mo, days| mo < month ? days : 0 }.sum + date

puts days
