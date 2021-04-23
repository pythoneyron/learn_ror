class Train
  MOVEMENT_NEXT = 'next'.freeze
  MOVEMENT_PREVIOUS = 'previous'.freeze

  TYPE_PASSENGER = 'passenger'.freeze
  TYPE_CARGO = 'cargo'.freeze

  NUMBER_FORMAT = /^[а-я0-9]{3}-?[а-я0-9]{2}$/i

  include NameCompany
  include InstanceCounter
  include ValidateData

  attr_accessor :speed, :current_station
  attr_reader :carriages, :number, :type, :route

  @@trains = [] # Доступно для всех подклассов.

  def self.find(num) # Фильтруем по всем экземплярам
    train = @@trains.filter { |train| train.number == num.to_s }
    train.empty? ? nil : train
  end

  def initialize(number, type)
    @number = number.chomp.to_s
    @type = type
    @carriages = []
    @speed = 0
    @@trains << self # Родительский initialize вызывается всегда, потому ставим это здесь, что бы добавлять все экземпляры

    validate
  end

  def stop_train
    self.speed = 0
  end

  def all_carriages_in_train(&block)
    carriages.each { |carriage| block.call(carriage) }
  end

  def type_train # для отображения в удобочитаемом виде
    type_train_msg = { TYPE_CARGO => 'грузовой', TYPE_PASSENGER => 'пассажирский' }
    type_train_msg[self.type]
  end

  def add_carriage(carriage)
    return 'Несоответствие типа поезда и вагона, вагон не добавлен' if type != carriage.type
    return 'Что бы прицепить вагон, необходимо остановить локоматив' unless speed.zero?
    return 'Этот вагон к поеду ранее уже был подцеплен' if carriages.include?(carriage)

    @carriages << carriage

    "Вагон '#{carriage.name}' к поезду '#{self.number}' подцеплен"
  end

  def remove_carriage(carriage)
    return 'Несоответствие типа поезда и вагона, вагон не отцеплен' if type != carriage.type
    return 'Что бы отцепить вагон, необходимо остановить локоматив' unless speed.zero?
    return 'Этот вагон у поезда отсутствует' unless carriages.include?(carriage)

    @carriages.delete(carriage)

    "Вагон '#{carriage.name}' у поезда '#{self.number}' отцеплен"
  end

  def route=(route)
    @route = route
    
    route.start.receive_trains(self)
    self.current_station = route.start  
  end

  def next_station
    full_route, current_index = full_route_with_index
    full_route[current_index + 1] if current_index <= full_route.length - 2
  end

  def previous_station
    full_route, current_index = full_route_with_index
    full_route[current_index - 1] unless current_index == 0
  end

  def movement_train_by_stations(movement)
    return "Поезду не назначен маршрут. Движение не возможно!" unless route

    if movement == MOVEMENT_NEXT
      station = next_station
      movement_impossible = "Станция #{self.current_station.name} конечная. Движение невозможно!"
    else
      station = previous_station
      movement_impossible = "Станция #{self.current_station.name} стартовая. Движение невозможно!"
    end

    return movement_impossible unless station

    self.current_station.delete_train(self)
    station.receive_trains(self)
    self.current_station = station

    "Поезд с номером #{self.number} прибыл на станцию #{self.current_station.name}"
  end

  private

  def full_route_with_index # Получение маршрута и текущего индекса, нужно только для методов текущего класса
    full_route = route.full_route
    current_index = full_route.find_index(current_station)

    [full_route, current_index]
  end

  def validate!
    raise 'Номер поезда не может быть пустым значением!' if number.empty?
    raise 'Тип поезда не может быть пустым значением!' if type.empty?
    raise "Номер поезда должен соответствовать формату ХХХ-ХХ или ХХХХХ где 'Х' число и/или кириллические буквы" if number !~ NUMBER_FORMAT
  end
end
