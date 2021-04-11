class Train
  attr_accessor :speed, :current_station

  attr_reader :carriages, :number, :type, :route

  def initialize(number, type)
    @number = number.to_s
    @type = type
    @carriages = []
    @speed = 0
  end

  def stop_train
    self.speed = 0
  end

  def add_carriage(carriage)
    return 'Несоответствие типа поезда и вагона, вагон не добавлен' if type != carriage.type
    return 'Что бы прицепить вагон, необходимо остановить локоматив' unless speed.zero?
    return 'Этот вагон к поеду ранее уже был подцеплен' if carriages.include?(carriage)

    @carriages << carriage

    "Вагон #{carriage.name}' к поезду '#{self.number}' подцеплен"
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

  def moving_next_station
    return "Поезду не назначен маршрут. Движение не возможно!" unless route

    station = next_station

    return "Станция #{self.current_station.name} конечная. Движение невозможно!" unless station

    self.current_station.delete_train(self)
    station.receive_trains(self)
    self.current_station = station

    "Поезд с номером #{self.number} прибыл на станцию #{self.current_station.name}"
  end

  def moving_previous_station
    return "Поезду не назначен маршрут. Движение не возможно!" unless route

    station = previous_station

    return "Станция #{self.current_station.name} конечная. Движение невозможно!" unless station

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
end
