class Carriage
  NAME_CARRIAGE_FORMAT = /^[а-я0-9]{5}$/i

  include NameCompany
  include ValidateData

  attr_reader :type, :name

  def initialize(name, type)
    @name = name
    @type = type

    validate
  end

  private

  def validate!
    raise 'Название вагона не может быть пустым значением!' if name.empty?
    raise 'Тип Вагона не может быть пустым значением!' if type.empty?
    raise 'Название вагона должно содержать как минимум пять символов!' if name !~ NAME_CARRIAGE_FORMAT
  end
end
