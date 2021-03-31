=begin
Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом).
Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара.

На основе введенных данных требуетеся:
Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением - вложенный хеш,
содержащий цену за единицу товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

puts 'Введите даные или "стоп" в названии товара, что бы остановить ввод.'

counter = 0
goods = {}

loop do
  counter += 1

  print "Название товара №#{counter}: "
  product = gets.chomp

  if product.include?('стоп')
    puts 'Ввод завершен'
    puts ''
    
    break
  end

  print 'Цена за единицу: '
  price = gets.chomp.to_f

  print 'Количество: '
  quantity = gets.chomp.to_f

  goods[product.to_sym] = {price: price, quantity: quantity}

  puts "Товар #{product} добавлен."
  puts ''
end

puts 'Добавленные вами товары:'
pp goods
puts ''

total_price_all_products = 0

goods.each do |name, data|
  total_price = data[:price] * data[:quantity]
  total_price_all_products += total_price

  puts "Итоговая цена за товар #{name} : #{total_price}"
end

puts '-----'
puts "Итоговая сумма всех покупок: #{total_price_all_products}"
