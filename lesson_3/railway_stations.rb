class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name 
    @trains = []
  end

  def receive_trains(train)
    @trains << train
  end

  def show_trains_by_type(type)
    trains.filter { |train| train.type == type }
  end

  def delete_train(train)
    @trains.delete(train)
  end

  def send_train(train)
    return "На станции #{self.name} нет поезда с номером #{train.number}" unless @trains.include?(train)

    delete_train(train)

    puts "Поезд #{train.number} отправлен со станции #{self.name}"

    train.next_station
  end

end


class Route
  attr_reader :start

  def initialize(start, stop)
    @start = start
    @stop = stop
    @intermediate_stations = []
  end

  def full_route
    [@start, @intermediate_stations, @stop].flatten!
  end

  def add_intermediate_stations(station)
    @intermediate_stations << station
  end

  def delete_intermediate_stations(station)
    if @intermediate_stations.include?(station)
      if station.trains.empty?
        @intermediate_stations.delete(station)

        return "Станция #{station.name} удалена"
      else
        return "На станции '#{station.name}' стоят поезда, удаление не возможно. "
      end
    end
    
    "Станция #{station.name} не является промежуточной, потому не может быть удалена."
  end

end


class Train
  attr_accessor :speed

  attr_reader :carriages, :current_station, :route, :number, :type

  TYPES_CARRIAGES = ['грузовой', 'пассажирский']

  def initialize(number, type, carriages)
    @number = number.to_s
    @type = type.to_s.downcase

    unless TYPES_CARRIAGES.include?(@type)
      raise 'Тип поезда может быть только "грузовой" или "пассажирский". Повторите ввод'
    end

    @carriages = carriages.to_i
    @speed = 0
  end

  def stop_train
    @speed = 0
  end

  def add_carriage
    return 'Что бы прицепить вагон, необходимо остановить локоматив' unless @speed.zero?

    @carriages += 1
  end

  def remove_carriage
    return 'Что бы отцепить вагон, необходимо остановить локоматив' unless @speed.zero?
    return 'У локомотива нет вагонов, нечего отцеплять' if @carriages.zero?

    @carriages -= 1
  end

  def set_route(route)
    @route = route
    @route.start.receive_trains(self)
    @current_station = @route.full_route[0]
  end
  
  def git_index_route
    route = @route.full_route
    index_route = route.find_index(@current_station)
  end

  def get_next_station
    index_route = git_index_route

    if index_route <= route.length - 2
      route[index_route + 1]
    end
  end

  def get_previon_station
    index_route = git_index_route
    
    unless index_route.zero?
      route[index_route -= 1]
    end
  end

  def moving_next_station
    next_station = get_next_station

    if next_station
      @current_station.delete_train(self)
      next_station.receive_trains(self)
      @current_station = next_station

      return "Поезд с номером #{self.number} прибыл на станцию #{@current_station.name}"
    end

    "Станция #{@current_station.name} конечная. Движение невозможно!"
  end

  def moving_previons_station
    previons_station = get_previon_station

    if previons_station
      @current_station.delete_train(self)
      previons_station.receive_trains(self)
      @current_station = previons_station

      return "Поезд с номером #{self.number} прибыл на станцию #{@current_station.name}"
    end

    "Станция #{@current_station.name} начальная. Движение невозможно!"
  end
end

# Заполнение данными для теста
station_a = Station.new('A')
station_b = Station.new('B')
station_c = Station.new('C')
station_d = Station.new('D')
station_e = Station.new('E')

route_a = Route.new(station_a, station_b)
route_b = Route.new(station_b, station_c)
route_c = Route.new(station_d, station_e)

route_a.add_intermediate_stations(station_c)
route_a.add_intermediate_stations(station_d)
route_a.add_intermediate_stations(station_e)

route_b.add_intermediate_stations(station_a)
route_b.add_intermediate_stations(station_d)
route_b.add_intermediate_stations(station_e)

train_a = Train.new(12, 'грузовой', 10)
train_b = Train.new(23, 'пассажирский', 5)
train_c = Train.new(34, 'грузовой', 2)
train_d = Train.new(45, 'пассажирский', 4)
train_e = Train.new(77, 'пассажирский', 7)

train_a.set_route(route_a)
train_b.set_route(route_a)
train_c.set_route(route_a)
train_d.set_route(route_a)
