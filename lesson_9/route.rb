# frozen_string_literal: true

class Route
  include InstanceCounter

  attr_reader :start, :stop

  @@routers = []

  def initialize(start, stop)
    @start = start
    @stop = stop
    @intermediate_stations = []
    @@routers << self

    register_instance
  end

  def full_route
    [@start, @intermediate_stations, @stop].flatten!
  end

  def add_intermediate_stations(station)
    @intermediate_stations << station
  end

  def delete_intermediate_stations(station)
    unless @intermediate_stations.include?(station)
      return "Станция #{station.name} не является промежуточной, потому не может быть удалена."
    end

    if station.trains.empty?
      @intermediate_stations.delete(station)
      return "Станция #{station.name} удалена"
    end

    "На станции '#{station.name}' стоят поезда, удаление не возможно. "
  end
end
