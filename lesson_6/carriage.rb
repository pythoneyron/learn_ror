class Carriage
  include NameCompany

  attr_reader :type, :name

  def initialize(name, type)
    @name = name
    @type = type
  end
end
