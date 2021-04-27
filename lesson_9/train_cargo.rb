# frozen_string_literal: true

class TrainCargo < Train
  TYPE_TRAIN = 'cargo'

  def initialize(number)
    super(number, TYPE_TRAIN)
    @number = number

    register_instance
  end
end
