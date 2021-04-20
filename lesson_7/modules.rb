module NameCompany
  def set_name_company(name)
    self.name = name
  end

  def show_name_company
    self.name
  end

  protected
  attr_accessor :name
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def self.extended(target)
      target.instance_variable_set(:@instances, 0)
      class << target; attr_accessor :instances end
    end

    def inherited(subclass)
      subclass.instance_variable_set(:@instances, 0)
      class << subclass; attr_accessor :instances end
    end
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.instances += 1
    end
  end
end

module ValidateData
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    def validate # Тут перехватываем исключение, отображаем ошибку
      validate!
    rescue RuntimeError => event
      puts event.message # Отображаем только сообщение пользователю
    end

    def valid? # Используется в файле main.rb. Если исключение, то сообщение об успешном создании объекта не отображается.
      validate!
      true
    rescue
      false
    end
  end
end