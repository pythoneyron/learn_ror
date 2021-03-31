# Заполнить массив числами фибоначчи до 100

fibonacci_numbers = Array.new
limit = 100

while true
  if fibonacci_numbers.length == 0
    fibonacci_numbers.push(0)

  elsif fibonacci_numbers.length == 1
    fibonacci_numbers.push(1)
  
  elsif (fibonacci_numbers[-2] + fibonacci_numbers[-1]) > limit
    break

  else
    fibonacci_numbers.push(fibonacci_numbers[-2] + fibonacci_numbers[-1])
  end
end

puts fibonacci_numbers
