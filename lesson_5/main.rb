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
  CREATE_CARRIAGES = 3
  CREATE_ROUTERS_AND_MANAGE_STATIONS = 4
  SET_ROUTE_TO_TRAIN = 5
  ADD_CARRIAGES_TO_TRAIN = 6
  REMOVE_CARRIAGE_FROM_TRAIN = 7
  MOVING_TRAIN_ON_ROUTE = 8
  SHOW_STATIONS_AND_TRAINS_ON_STATION = 9

  # для метода create_trains
  PASSENGER = 1
  CARGO = 2

  # для метода manage_station и add_remove_intermediate_stations
  ADD_STATION = 1
  DELETE_STATION = 2
  MANAGE_STATIONS_IN_ROUTERS = 2
  SHOW_STATIONS_IN_ROUTE = 3

  # для метода moving_train_on_route
  MOVING_NEXT = 1
  MOVING_PREVIOUS = 2

  # для метода moving_train_on_route
  MOVEMENT_NEXT = 'next'.freeze
  MOVEMENT_PREVIOUS = 'previous'.freeze

  puts "Это программа абстрактной модели железной дороги"

  station_moscow = Station.new('Москва')
  station_surgut = Station.new( 'Сургут')
  station_tymen = Station.new( 'Тюмень')

  route = Route.new(station_moscow, station_surgut)
  route.add_intermediate_stations(station_tymen)

  train_cargo = TrainCargo.new('111')
  train_pass = TrainPassenger.new('222')

  train_cargo.route=(route)
  train_pass.route=(route)

  carriage_cargo_platform = CarriageCargo.new('платформа')
  carriage_cargo_container = CarriageCargo.new('контейнер')

  carriage_pass_restaurant = CarriagePassenger.new('ресторан')
  carriage_pass_reserved_seat = CarriagePassenger.new('плацкарт')

  train_cargo.add_carriage(carriage_cargo_platform)
  train_cargo.add_carriage(carriage_cargo_container)

  train_pass.add_carriage(carriage_pass_restaurant)
  train_pass.add_carriage(carriage_pass_reserved_seat)

  def menu_items
    puts "\n1 - Создавать станции"
    puts '2 - Создавать поезда'
    puts '3 - Создавать вагоны'
    puts '4 - Создавать маршруты и управлять станциями в нем (добавлять, удалять, просматривать)'
    puts '5 - Назначать маршрут поезду'
    puts '6 - Добавлять вагоны к поезду'
    puts '7 - Отцеплять вагоны от поезда'
    puts '8 - Перемещать поезд по маршруту вперед и назад'
    puts '9 - Просматривать список станций и список поездов на станции'
    puts "0 - Выход"
    print "\nВыберите нужный вариант: "
  end

  def start_program
    loop do
      menu_items

      option = gets.chomp.to_i
      break if option.zero?

      create_stations if option == CREATE_STATIONS
      create_trains if option == CREATE_TRAINS
      create_carriages if option == CREATE_CARRIAGES
      create_routers_and_manage_station if option == CREATE_ROUTERS_AND_MANAGE_STATIONS
      set_route_to_train if option == SET_ROUTE_TO_TRAIN
      add_carriages_to_train if option == ADD_CARRIAGES_TO_TRAIN
      remove_carriage_from_train if option == REMOVE_CARRIAGE_FROM_TRAIN
      moving_train_on_route if option == MOVING_TRAIN_ON_ROUTE
      show_stations_and_trains_on_stations if option == SHOW_STATIONS_AND_TRAINS_ON_STATION
    end
  end

  def create_stations
    loop do
      print "\nВведите название станции или 0 что бы выйти: "

      name = gets.chomp
      return if name == '0'

      station = Station.new(name)
      puts "Станция с названием '#{station.name}' создана."
    end
  end

  def create_trains
    loop do
      puts '1 - Пассажирский'
      puts '2 - Грузовой'
      print "\nВыберите тип поезда или 0 что бы выйти: "

      type = gets.chomp.to_i
      return if type.zero?

      if type == PASSENGER
        print 'Введите номер пассажирского поезда: '

        number = gets.chomp
        train_passenger = TrainPassenger.new(number)

        puts "\nПассажирский поезд с номером '#{train_passenger.number}' создан.\n"
      end

      if type == CARGO
        print 'Введите номер грузового поезда: '

        number = gets.chomp
        train_cargo = TrainCargo.new(number)

        puts "\nГрузовой поезд с номером '#{train_cargo.number}' создан.\n"
      end
    end
  end

  def create_carriages
    loop do
      puts '1 - Пассажирский'
      puts '2 - Грузовой'
      print "\nВыберите тип вагона или 0 что бы выйти: "

      type = gets.chomp.to_i
      return if type.zero?

      if type == PASSENGER
        print 'Введите название пассажирского вагона: '

        name = gets.chomp
        carriage_passenger = CarriagePassenger.new(name)

        puts "\nПассажирский вагон '#{carriage_passenger.name}' создан.\n"
      end

      if type == CARGO
        print 'Введите название грузового вагона: '

        name = gets.chomp
        carriage_cargo = CarriageCargo.new(name)

        puts "\nГрузовой вагон '#{carriage_cargo.name}' создан.\n"
      end
    end
  end

  def create_routers
    stations = array_class_objects(Station)

    return puts "\nДля построения маршрута требуется как минимум две станции. Создайте станции в основном меню!" if stations.empty?

    puts "\nНиже выведен список ранее созданных станций:"

    display_stations(stations)

    print "\nВыберите номер первой станции или 0 что бы выйти: "
    first = gets.chomp.to_i
    return if first.zero?

    first_station = stations[first - 1]

    print "\nВыберите номер конечной станции или 0 что бы выйти: "
    last = gets.chomp.to_i
    return if last.zero?

    last_station = stations[last - 1]

    return puts 'Одна или две станции не выбраны. Маршрут не создан' if [first_station, last_station].include?(nil)

    if first_station != last_station
      route = Route.new(first_station, last_station)
      puts "\nМаршрут со станциями '#{first_station.name}' и '#{last_station.name}' создан.\n"
    else
      puts and return "\nВыбраны несуществующие пункты меню или выбраны одинаковые станции. Маршрут не создан!\n"
    end

    puts "\n1 - Добавить промежуточные станции"
    puts '0 - Выход'
    print 'Введите значение: '

    option = gets.chomp.to_i
    return if option != 1

    puts "\n\nНиже выведен список ранее созданных станций: "

    add_remove_intermediate_stations(ADD_STATION, route)
  end

  def manage_station
    loop do
      routers = array_class_objects(Route)

      return puts "\nДля управления станциями в маршруте необходимо создать маршрут. Создайте маршруты!" if routers.empty?

      puts "\nНиже выведен список ранее созданных маршрутов:"

      display_routers(routers)

      print "\nВыберите номер маршрута для редактирования или введите 0 что бы выйти: "
      route = gets.chomp.to_i

      return if route.zero?

      route = routers[route - 1]

      next unless route

      puts "\n1 - Добавить станцию в выбранном маршруте"
      puts '2 - Удалить станцию в выбранный маршруте'
      puts '0 - Выход'
      print 'Введите значение: '

      add_or_del = gets.chomp.to_i

      return if add_or_del.zero?
      next if add_or_del > 2

      puts "\nНиже выведен список ранее созданных станций: "

      add_remove_intermediate_stations(ADD_STATION, route) if add_or_del == ADD_STATION
      add_remove_intermediate_stations(DELETE_STATION, route) if add_or_del == DELETE_STATION
    end
  end

  def show_stations_in_route
    loop do
      routers = array_class_objects(Route)

      return puts "\nДля просмотра станции в маршруте необходимо создать маршрут. Создайте маршруты!" if routers.empty?

      puts "\nНиже выведен список ранее созданных маршрутов:"

      display_routers(routers)

      print "\nВыбирите маршрут или введите 0 что бы выйти: "
      route = gets.chomp.to_i

      return if route.zero?

      route = routers[route - 1]

      next unless route

      stations = array_class_objects(Station, route)
      display_stations(stations)
    end
  end

  def create_routers_and_manage_station
    loop do
      puts "\n1 - Создать маршрут"
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
  end

  def set_route_to_train
    trains = array_class_objects(Train)
    return puts "\nДля назначения поезду маршрута необходимо создать поезд. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print "\nВыберите поезд или ведите 0 что бы выйти: "
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    routers = array_class_objects(Route)
    return puts "\nДля назначения поезду маршрута необходимо создать маршрут. Создайте маршруты!" if routers.empty?
    puts "\nНиже выведен список ранее созданных маршрутов:"

    display_routers(routers)

    print 'Введите 0 что бы выйти: '
    route = gets.chomp.to_i
    return if route.zero?

    route = routers[route - 1]

    train.route=(route)
    puts "\nПоезду #{train.number} назначен маршрут #{route.start.name} -> #{route.stop.name}"
  end

  def add_carriages_to_train
    trains = array_class_objects(Train)
    return puts "\nДля добавления вагонов к поезду необходимо создать поезд. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print "\nВыберите поезд или ведите 0 что бы выйти: "
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    carriages = array_class_objects(Carriage).filter{ |carriage| carriage.type == train.type }
    return puts "\nДля добавления вагонов к поезду необходимо создать вагоны. Создайте вагоны!" if carriages.empty?
    puts 'Ниже выведен список ранее созданных вагонов:'

    display_carriages(carriages)

    print "\nВыберите вагон или ведите 0 что бы выйти: "
    carriage = gets.chomp.to_i
    return if carriage.zero?

    carriage = carriages[carriage - 1]

    puts train.add_carriage(carriage)
  end

  def remove_carriage_from_train
    trains = array_class_objects(Train)
    return puts "\nДля удаления вагонов к поезда необходимо создать поезд. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print "\nВыберите поезд или ведите 0 что бы выйти: "
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    carriages = train.carriages

    return puts "\nУ поезда отсутствуют вагоны" if carriages.empty?
    puts 'Ниже выведен список ранее созданных вагонов:'

    display_carriages(carriages)

    print "\nВыберите вагон или ведите 0 что бы выйти: "
    carriage = gets.chomp.to_i
    return if carriage.zero?

    carriage = carriages[carriage - 1]

    puts train.remove_carriage(carriage)
  end

  def moving_train_on_route
    trains = array_class_objects(Train)
    return puts "\nДля перемещения поезда его необходимо создать. Создайте поезда!" if trains.empty?
    puts 'Ниже выведен список ранее созданных поездов:'

    display_trains(trains)

    print "\nВыберите поезд или ведите 0 что бы выйти: "
    train = gets.chomp.to_i
    return if train.zero?

    train = trains[train - 1]

    loop do
      puts "\n1 - Движение вперед"
      puts '2 - Движение назад'
      puts '0 - Выход'
      print 'Введите значение: '

      moving = gets.chomp.to_i
      return if moving.zero?

      puts train.movement_train_by_stations(MOVEMENT_NEXT) if moving == MOVING_NEXT
      puts train.movement_train_by_stations(MOVEMENT_PREVIOUS) if moving == MOVING_PREVIOUS
    end
  end

  def show_stations_and_trains_on_stations
    loop do
      stations = array_class_objects(Station)

      return puts "\nСтанции не найдены" if stations.empty?

      display_stations(stations)

      print "\nВыберите номер станции для просмотра поездов или 0 что бы выйти: "
      stations_index = gets.chomp.to_i
      return if stations_index.zero?

      station = stations[stations_index - 1]

      next unless station

      puts "\nНа станции '#{station.name}' поездов еще нет" if station.trains.empty?

      puts "\nПоезда на станции #{station.name}:"
      station.trains.each { |train| puts "#{train.number} - #{train.type}" }
      puts "\n" # раздилитель между списками

    end
  end

  def add_remove_intermediate_stations(action, route)
    loop do
      stations = array_class_objects(Station)
      display_stations(stations)

      print "\nВыберите номер промежуточной станции или 0 что бы выйти: "
      intermediate = gets.chomp.to_i
      return if intermediate.zero?

      intermediate = stations[intermediate - 1]

      next unless intermediate

      if action == ADD_STATION
        if route.full_route.include?(intermediate)
          puts "\nСтанция '#{intermediate.name}' ранее уже была добавлена в маршрут. Выберите другую станцию."
          next
        end

        route.add_intermediate_stations(intermediate)
        puts "\nПромежуточная станция '#{intermediate.name}' добавлена."
      else
        puts "\n" # # раздилитель между пунктами
        puts route.delete_intermediate_stations(intermediate)
      end
    end
  end

  private

  # Эти методы используются только в рамках текущего класса
  def display_stations(stations)
    stations.each_with_index { |station, index| puts "#{index + 1} - #{station.name}" }
  end

  def display_routers(routers)
    routers.each_with_index { |route, index| puts "#{index + 1} - #{route.start.name} -> #{route.stop.name}" }
  end

  def display_trains(trains)
    trains.each_with_index { |train, index| puts "#{index + 1} - #{train.number} : #{train.type}" }
  end

  def display_carriages(carriages)
    carriages.each_with_index { |carriage, index| puts "#{index + 1} - #{carriage.name}" }
  end

  def array_class_objects(class_name, route = false)
    return route.full_route if route
    ObjectSpace.each_object(class_name).to_a
  end
end

RailsRoad.new.start_program
