# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).

vowels = {}

alphabet = ('a'..'z')

alphabet.each_with_index do |letter, index|
  if 'aeiouy'.include? letter
    vowels[letter] = index + 1
  end
end

puts vowels

