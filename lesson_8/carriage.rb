class Carriage
  NAME_CARRIAGE_FORMAT = /^[а-я0-9]{5,100}$/i

  TYPE_PASSENGER = 'passenger'.freeze
  TYPE_CARGO = 'cargo'.freeze

  include NameCompany
  include ValidateData

  attr_accessor :used_size
  attr_reader :type, :name, :size

  def initialize(name, size, type)
    @name = name
    @type = type
    @size = size.to_i
    @used_size = 0

    validate
  end

  def free_volume
    size - used_size
  end

  def type_carriage # для отображения в удобочитаемом виде
    type_carriage_msg = { TYPE_CARGO => 'грузовой', TYPE_PASSENGER => 'пассажирский' }
    type_carriage_msg[self.type]
  end

  def type_volume # для отображения в удобочитаемом виде
    type_volume = { TYPE_CARGO => 'объема', TYPE_PASSENGER => 'места' }
    type_volume[self.type]
  end

  def use_volume(volume = 1) # Этот метод требуется только для текущего класса и его подклассов
    return 'Передано пустое значение, 0 или строка. Очидается число больше 0!' if volume == 0
    return "Свободного #{self.type_volume} в вагоне нет!" if self.size == self.used_size
    return "Переданное количество #{self.type_volume} займет больше, чем свободно! Доступно: #{self.size - self.used_size}" if (self.used_size + volume) > self.size

    self.used_size += volume

    "Количество #{self.type_volume} '#{volume}' успешно занято. Осталось свободным: '#{self.size - self.used_size}'"
  end

  private

  def validate!
    raise 'Название вагона не может быть пустым значением!' if name.empty?
    raise 'Тип Вагона не может быть пустым значением!' if type.empty?
    raise "Получена строка или пустое значение! Объем или место в вагоне не может быть пустым значением! Ожидается число больше 0!" if size.zero?
    raise 'Название вагона должно содержать как минимум пять символов и может содержать число и/или кириллические буквы!' if name !~ NAME_CARRIAGE_FORMAT
  end
end
