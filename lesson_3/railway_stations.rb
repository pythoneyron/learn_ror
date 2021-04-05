class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name 
    @trains = []
  end

  def receive_trains(train)
    @trains << train
  end

  def show_trains_by_type
    types_trains = {}

    for train in trains
      if types_trains.key?(train.type)
        types_trains[train.type] += 1
      else
        types_trains[train.type] = 1
      end
    end
    
    types_trains.each { |key, value| puts "Тип #{key} количество: #{value}" }
  end

  def send_train(train)
    return "На станции #{self.name} нет поезда с номером #{train.number}" unless @trains.include?(train)

    @trains.delete(train)

    puts "Поезд #{train.number} отправлен со станции #{self.name}"

    train.next_station
  end

  def show_number_trains
    trains.map { |train| train.number }
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

  def show_stations
    full_route.each { |station| puts station.name }
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
  
  def next_station
    route = @route.full_route
    index_route = route.find_index(@current_station)
    
    if index_route <= route.length - 2
      @current_station = route[index_route + 1]
      @current_station.receive_trains(self)

      return "Поезд с номером #{self.number} прибыл на станцию #{@current_station.name}"
    end

    "Станция #{@current_station.name} конечная. Движение невозможно!"
  end

  def previons_station
    route = @route.full_route
    index_route = route.find_index(@current_station)
    
    unless index_route.zero?
      @current_station = route[index_route -= 1]
      @current_station.receive_trains(self)

      return "Поезд с номером #{self.number} прибыл на станцию #{@current_station.name}"
    end

    "Станция #{@current_station.name} начальная. Движение невозможно!"
  end

  def show_stations
    @route.full_route.map { |station| station.name }
  end

  def show_previons_current_next_station
    full_route = @route.full_route
    current_index = full_route.find_index(@current_station)
    
    if  current_index == 0 && full_route.length >= 2
      return "Предыдущей станции нет. Текущая станция: '#{current_station.name}' начальная. Cледующая станция '#{full_route[current_index + 1].name}'"
    elsif current_index == full_route.length - 1  && full_route.length >= 2
      return "Предыдущая станция '#{full_route[current_index - 1].name}' Текущая станция: '#{current_station.name}' конечная. Следующей станции нет, "
    end

    "Предыдущая станция: '#{full_route[current_index - 1].name}' Текущая станция: '#{current_station.name}' Следующая станция: '#{full_route[current_index + 1].name}'"
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
train_e.set_route(route_b)

train_a.show_previons_current_next_station
train_a.show_stations
train_a.next_station
train_a.show_previons_current_next_station
