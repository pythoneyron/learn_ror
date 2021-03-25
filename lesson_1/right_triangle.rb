=begin
Прямоугольный треугольник.
Программа запрашивает у пользователя 3 стороны треугольника и определяет, является ли треугольник прямоугольным
(используя теорему Пифагора www-formula.ru), равнобедренным (т.е. у него равны любые 2 стороны)
или равносторонним (все 3 стороны равны) и выводит результат на экран.
Подсказка: чтобы воспользоваться теоремой Пифагора, нужно сначала найти самую длинную сторону (гипотенуза)
и сравнить ее значение в квадрате с суммой квадратов двух остальных сторон. Если все 3 стороны равны,
то треугольник равнобедренный и равносторонний, но не прямоугольный.
=end

puts 'Укажите первую сторону треугольника'
side_a = gets.chomp.to_i

puts 'Укажите вторую сторону треугольника'
side_b = gets.chomp.to_i

puts 'Укажите третью сторону треугольника'
side_c = gets.chomp.to_i

if side_a == side_b && side_b == side_c
  puts "Треугольник равносторонний"
else
  sides = [side_a, side_b, side_c]
  long_side = sides.sort.pop # Вырезаем максимально большое значение
  sum_side_a_and_b = sides[0..1].map{|n| n ** 2}.sum # Возводим в квадрат каждое значение массива и суммируем

  if long_side ** 2 == sum_side_a_and_b
    puts "Треугольник прямоугольный"
  elsif sides.uniq.length < sides.length # Если уникальных объектов меньше, значит есть как минимум два одинковых числа
    puts "Треугольник равнобедренный"
  else
    puts "Треугольник не существует"
  end
end
