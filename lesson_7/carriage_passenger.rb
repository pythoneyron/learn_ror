class CarriagePassenger < Carriage
  TYPE_CARRIAGE = 'passenger'.freeze

  def initialize(name)
    super(name, TYPE_CARRIAGE)
  end
end