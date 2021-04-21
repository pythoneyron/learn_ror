class CarriageCargo < Carriage
  TYPE_CARRIAGE = 'cargo'.freeze

  def initialize(name)
    super(name, TYPE_CARRIAGE)
  end
end