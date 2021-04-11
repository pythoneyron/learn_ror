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
    train.next_station

    "Поезд #{train.number} отправлен со станции #{self.name}"
  end
end