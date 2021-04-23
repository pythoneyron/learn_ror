class Station
  NAME_STATION_FORMAT = /^[а-я0-9]{2,100}$/i

  attr_reader :trains, :name

  include InstanceCounter
  include ValidateData

  @@stasions = []

  def self.all
    @@stasions
  end

  def initialize(name)
    @name = name 
    @trains = []
    @@stasions << self
    self.register_instance

    validate
  end

  def receive_trains(train)
    @trains << train
  end

  def all_trains_in_station(&block)
    trains.each { |train| block.call(train) }
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

  private

  def validate!
    raise 'Название станции не может быть пустым значением!' if name.empty?
    raise 'Название станции должно содержать как минимум два символа, число и/или кириллические буквы!' if name !~ NAME_STATION_FORMAT
  end
end