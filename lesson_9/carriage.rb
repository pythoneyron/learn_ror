# frozen_string_literal: true

class Carriage
  include NameCompany
  include ValidateData

  TYPE_PASSENGER = 'passenger'
  TYPE_CARGO = 'cargo'

  NAME_CARRIAGE_FORMAT = /^[а-я0-9]{5,100}$/i.freeze

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

  # для отображения в удобочитаемом виде
  def type_carriage
    type_carriage_msg = { TYPE_CARGO => 'грузовой', TYPE_PASSENGER => 'пассажирский' }
    type_carriage_msg[type]
  end

  # для отображения в удобочитаемом виде
  def type_volume
    type_volume = { TYPE_CARGO => 'объема', TYPE_PASSENGER => 'места' }
    type_volume[type]
  end

  # Этот метод требуется только для текущего класса и его подклассов
  def use_volume(volume = 1)
    return 'Передано пустое значение, 0 или строка. Очидается число больше 0!' if volume.zero?
    return "Свободного #{type_volume} в вагоне нет!" if size == used_size
    if (used_size + volume) > size
      return "Переданное количество #{type_volume} займет больше, чем свободно! Доступно: #{size - used_size}"
    end

    self.used_size += volume

    "Количество #{type_volume} '#{volume}' успешно занято. Осталось свободным: '#{size - used_size}'"
  end

  private

  def validate!
    raise 'Название вагона не может быть пустым значением!' if name.empty?
    raise 'Тип Вагона не может быть пустым значением!' if type.empty?

    if size.zero?
      raise 'Получена строка или пустое значение! Объем или место в вагоне не может быть пустым значением! Ожидается число больше 0!'
    end

    if name !~ NAME_CARRIAGE_FORMAT
      raise 'Название вагона должно содержать как минимум пять символов и может содержать число и/или кириллические буквы!'
    end
  end
end
