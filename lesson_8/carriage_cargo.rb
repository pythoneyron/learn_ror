class CarriageCargo < Carriage
  TYPE_CARRIAGE = 'cargo'.freeze

  def initialize(name, volume)
    super(name, volume, TYPE_CARRIAGE)
  end
end