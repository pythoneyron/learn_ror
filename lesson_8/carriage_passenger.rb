class CarriagePassenger < Carriage
  TYPE_CARRIAGE = 'passenger'.freeze

  def initialize(name, seat)
    super(name, seat, TYPE_CARRIAGE)
  end
end