# frozen_string_literal: true

class CarriagePassenger < Carriage
  TYPE_CARRIAGE = 'passenger'

  def initialize(name, seat)
    super(name, seat, TYPE_CARRIAGE)
  end
end
