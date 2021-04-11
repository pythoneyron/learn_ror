require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'train_passenger'
require_relative 'train_cargo'
require_relative 'carriage'
require_relative 'carriage_passenger'
require_relative 'carriage_cargo'

class RailsRoad
  CREATE_STATIONS = 1
  CREATE_TRAINS = 2
  CREATE_ROUTERS_AND_MANAGE_STATIONS = 3
  SET_ROUTE_TO_TRAIN = 4
  ADD_CARRIAGES_TO_TRAIN = 5
  REMOVE_CARRIAGE_FROM_TRAIN = 6
  MOVING_TRAIN_ON_ROUTE = 7
  SHOW_STATIONS_AND_TRAINS_ON_STATION = 8

  # для метода create_trains
  PASSENGER = 1
  CARGO = 2

  # для метода manage_station
  ADD_STATION = 1
  DELETE_STATION = 2
  MANAGE_STATIONS_IN_ROUTERS = 2
  SHOW_STATIONS_IN_ROUTE = 3

  # для метода moving_train_on_route
  MOVING_NEXT = 1
  MOVING_PREVIOUS = 2

  puts "Это программа абстрактной модели железной дороги"

  def start_program
    loop do
      puts "\n\n1 - Создавать станции"
      puts '2 - Создавать поезда'
      puts '3 - Создавать маршруты и управлять станциями в нем (добавлять, удалять, просматривать)'
      puts '4 - Назначать маршрут поезду'
      puts '5 - Добавлять вагоны к поезду'
      puts '6 - Отцеплять вагоны от поезда'
      puts '7 - Перемещать поезд по маршруту вперед и назад'
      puts '8 - Просматривать список станций и список поездов на станции'
      puts "0 - Выход\n\n"
      print 'Выберите нужный вариант: '

      option = gets.chomp.to_i

      break if option.zero?

      create_stations if option == CREATE_STATIONS
      create_trains if option == CREATE_TRAINS
      create_routers_and_manage_station if option == CREATE_ROUTERS_AND_MANAGE_STATIONS
      set_route_to_train if option == SET_ROUTE_TO_TRAIN
      add_carriages_to_train if option == ADD_CARRIAGES_TO_TRAIN
      remove_carriage_from_train if option == REMOVE_CARRIAGE_FROM_TRAIN
      moving_train_on_route if option == MOVING_TRAIN_ON_ROUTE
      show_stations_and_trains_on_stations if option == SHOW_STATIONS_AND_TRAINS_ON_STATION
    end
  end

  def create_stations
    print 'Введите название станции или 0 что бы выйти: '

    name = gets.chomp

    return if name == '0'

    station = Station.new(name)
    puts "\n\nСтанция с названием '#{station.name}' создана.\n\n"
  end

  def create_trains
    puts '1 - Пассажирский'
    puts '2 - Грузовой'
    print 'Выберите тип поезда: '

    type = gets.chomp.to_i

    if type == PASSENGER
      print 'Введите номер пассажирского поезда: '

      number = gets.chomp
      train_passenger = TrainPassenger.new(number)

      puts "\n\nПассажирский поезд с номером '#{train_passenger.number}' создан.\n\n"
    end

    if type == CARGO
      print 'Введите номер грузового поезда: '

      number = gets.chomp
      train_cargo = TrainCargo.new(number)

      puts "\n\nГрузовой поезд с номером '#{train_cargo.number}' создан.\n\n"
    end
  end

  def create_routers
    stations = stations_array

    return puts "\n\nДля построения маршрута требуется как минимум две станции. Создайте станции в основном меню!" if stations.empty?

    puts "\n\nДля создания марштрута требуется две станции."
    puts 'Ниже выведен список ранее созданных станций:'

    display_stations(stations)

    print 'Выберите номер первой станции или 0 что бы выйти: '
    first = gets.chomp.to_i
    return if first.zero?

    first_station = stations[first - 1]

    print 'Выберите номер конечной станции или 0 что бы выйти: '
    last = gets.chomp.to_i
    return if last.zero?

    last_station = stations[last - 1]

    return puts 'Одна или две станции не выбраны. Маршрут не создан' if [first_station, last_station].include?(nil)

    if first_station != last_station
      route = Route.new(first_station, last_station)
      puts "Маршрут со станциями '#{first_station.name}' и '#{last_station.name}' создан.\n\n" 
    else
      puts and return "\n\nНачальная и конечная станция не могут быть одинаковы\n\n"
    end

    puts '1 - Добавить промежуточные станции'
    puts '0 - Выход'
    print 'Введите значение: '

    option = gets.chomp.to_i
    return if option.zero?

    puts "Ниже выведен список ранее созданных станций: "
    
    add_intermediate_stations(route)
  end

  def manage_station
    routers = routers_array

    return puts "\n\nДля управления станциями в маршруте необходимо создать маршрут. Создайте маршруты!" if routers.empty?

    puts 'Ниже выведен список ранее созданных маршрутов:'

    display_routers(routers)

    print 'Выберите номер маршрута для редактирования или введите 0 что бы выйти: '
    route = gets.chomp.to_i

    return if route.zero?

    route = routers[route - 1]
    
    puts '1 - Добавить станцию в выбранном маршруте'
    puts '2 - Удалить станцию в выбранный маршруте'
    print 'Введите значение: '

    add_or_del = gets.chomp.to_i

    puts "\n\nНиже выведен список ранее созданных станций: "
    
    add_intermediate_stations(route) if add_or_del == ADD_STATION
    delete_intermediate_stations(route) if add_or_del == DELETE_STATION
  end

  def show_stations_in_route
    routers = routers_array

    return puts "\n\nДля просмотра станции в маршруте необходимо создать маршрут. Создайте маршруты!" if routers.empty?

    puts 'Ниже выведен список ранее созданных маршрутов:'

    display_routers(routers)

    print 'Введите 0 что бы выйти: '
    route = gets.chomp.to_i

    return if route.zero?

    route = routers[route - 1]

    stations = stations_array(route)
    display_stations(stations)
  end

  def create_routers_and_manage_station
    puts '1 - Создать маршрут'
    puts '2 - Добавить или удалить станции с маршрута'
    puts '3 - Просмотреть станции в маршруте'
    puts '0 - Выход'
    print 'Введите значение: '

    option = gets.chomp.to_i

    return if option.zero?

    create_routers if option == ADD_STATION
    manage_station if option == MANAGE_STATIONS_IN_ROUTERS
    show_stations_in_route if option == SHOW_STATIONS_IN_ROUTE
  end

  def set_route_to_train
    trains = trains_array
    return puts "\n\nДля назначения поезду маршрута необходимо создать поезд. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print 'Выберите поезд или ведите 0 что бы выйти: '
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    routers = routers_array
    return puts "\n\nДля назначения поезду маршрута необходимо создать маршрут. Создайте маршруты!" if routers.empty?
    puts 'Ниже выведен список ранее созданных маршрутов:'

    display_routers(routers)

    print 'Введите 0 что бы выйти: '
    route = gets.chomp.to_i
    return if route.zero?

    route = routers[route - 1]

    train.route=(route)
    puts "\n\nПоезду #{train.number} назначен маршрут #{route.start.name} -> #{route.stop.name}"
  end

  def add_carriages_to_train
    trains = trains_array
    return puts "\n\nДля добавления вагонов к поезду необходимо создать поезд. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print 'Выберите поезд или ведите 0 что бы выйти: '
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    carriages = carriages_array.filter{ |carriage| carriage.type == train.type }
    return puts "\n\nДля добавления вагонов к поезду необходимо создать вагоны. Создайте вагоны!" if carriages.empty?
    puts 'Ниже выведен список ранее созданных вагонов:'

    display_carriages(carriages)

    print 'Выберите вагон или ведите 0 что бы выйти: '
    carriage = gets.chomp.to_i
    return if carriage.zero?

    carriage = carriages[carriage - 1]

    puts train.add_carriage(carriage)
  end

  def remove_carriage_from_train
    trains = trains_array
    return puts "\n\nДля удаления вагонов к поезда необходимо создать поезд. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print 'Выберите поезд или ведите 0 что бы выйти: '
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    carriages = train.carriages

    return puts "\n\nУ поезда отсутствуют вагоны" if carriages.empty?
    puts 'Ниже выведен список ранее созданных вагонов:'

    display_carriages(carriages)

    print 'Выберите вагон или ведите 0 что бы выйти: '
    carriage = gets.chomp.to_i
    return if carriage.zero?

    carriage = carriages[carriage - 1]

    puts train.remove_carriage(carriage)
  end

  def moving_train_on_route
    trains = trains_array
    return puts "\n\nДля перемещения поезда его необходимо создать. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print 'Выберите поезд или ведите 0 что бы выйти: '
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    puts '1 - Движение вперед'
    puts '2 - Движение назад'
    puts '0 - Выход'
    print 'Введите значение: '

    moving = gets.chomp.to_i
    return if moving.zero?

    puts train.moving_next_station if moving == MOVING_NEXT
    puts train.moving_previous_station if moving == MOVING_PREVIOUS
  end

  def show_stations_and_trains_on_stations
    stations = stations_array

    return puts "\n\nСтанции не найдены" if stations.empty?

    display_stations(stations)

    print 'Выберите номер станции для просмотра поездов или 0 что бы выйти: '
    stations_index = gets.chomp.to_i
    return if stations_index.zero?

    station = stations[stations_index - 1]
    station.trains.each { |train| puts "#{train.number} - #{train.type}" }
  end

  def add_intermediate_stations(route)
    loop do
      stations = stations_array
      display_stations(stations)

      print 'Выберите номер промежуточной станции или 0 что бы выйти: '
      intermediate = gets.chomp.to_i
      return if intermediate.zero?

      intermediate = stations[intermediate - 1]

      if route.full_route.include?(intermediate)
        puts "Станция '#{intermediate.name}' ранее уже была добавлена в маршрут. Выберите другую станцию."
      else
        route.add_intermediate_stations(intermediate)

        puts "Промежуточная станция '#{intermediate.name}' добавлена.\n\n"

        print "Продолжить добавление промежуточных станций?\n\n"
        puts '1 - Да'
        puts '0 - Выход'
        print 'Введите значение: '
    
        continue = gets.chomp.to_i

        return if continue.zero?
      end
    end
  end

  def delete_intermediate_stations(route)
    loop do
      stations = stations_array(route)
      display_stations(stations)

      print 'Выберите номер промежуточной станции или 0 что бы выйти: '
      intermediate = gets.chomp.to_i
      return if intermediate.zero?

      intermediate = stations[intermediate - 1]

      puts route.delete_intermediate_stations(intermediate)

      print "Продолжить удаление промежуточных станций?\n\n"
      puts '1 - Да'
      puts '0 - Выход'
      print 'Введите значение: '
  
      continue = gets.chomp.to_i

      return if continue.zero?
    end
  end

  private

  # Эти методы используются только в рамках текущего класса
  def display_stations(stations)
    stations.each_with_index { |station, index| puts "#{index + 1} - #{station.name}" }
  end

  def stations_array(route = false)
    return route.full_route if route
    ObjectSpace.each_object(Station).to_a
  end

  def display_routers(routers)
    routers.each_with_index { |route, index| puts "#{index + 1} - #{route.start.name} -> #{route.stop.name}" }
  end

  def routers_array
    ObjectSpace.each_object(Route).to_a
  end

  def display_trains(trains)
    trains.each_with_index { |train, index| puts "#{index + 1} - #{train.number}" }
  end

  def trains_array
    ObjectSpace.each_object(Train).to_a
  end

  def display_carriages(carriages)
    carriages.each_with_index { |carriage, index| puts "#{index + 1} - #{carriage.name}" }
  end

  def carriages_array
    ObjectSpace.each_object(Carriage).to_a
  end
end

RailsRoad.new.start_program
