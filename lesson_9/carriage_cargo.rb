# frozen_string_literal: true

class CarriageCargo < Carriage
  TYPE_CARRIAGE = 'cargo'

  def initialize(name, volume)
    super(name, volume, TYPE_CARRIAGE)
  end
end
