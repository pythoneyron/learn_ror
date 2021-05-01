# frozen_string_literal: true

class TrainPassenger < Train
  TYPE_TRAIN = 'passenger'

  def initialize(number)
    super(number, TYPE_TRAIN)
    @number = number

    register_instance
  end
end
