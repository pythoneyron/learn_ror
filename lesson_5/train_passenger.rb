class TrainPassenger < Train
  TYPE_TRAIN = 'passenger'.freeze

  def initialize(number)
    super(number, TYPE_TRAIN)
    @number = number
  end
end