# frozen_string_literal: true

class Station
  include InstanceCounter
  # include ValidateData
  include Validation

  NAME_STATION_FORMAT = /^[а-я0-9]{2,100}$/i.freeze

  attr_reader :trains, :name

  validate :name, :presence
  validate :name, :format, NAME_STATION_FORMAT

  @@stasions = []

  def self.all
    @@stasions
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stasions << self
    register_instance

    validate!
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
    return "На станции #{name} нет поезда с номером #{train.number}" unless @trains.include?(train)

    delete_train(train)
    train.next_station

    "Поезд #{train.number} отправлен со станции #{name}"
  end

  # private

  # def validate!
  #   raise 'Название станции не может быть пустым значением!' if name.empty?
  #   if name !~ NAME_STATION_FORMAT
  #     raise 'Название станции должно содержать как минимум два символа, число и/или кириллические буквы!'
  #   end
  # end
end
