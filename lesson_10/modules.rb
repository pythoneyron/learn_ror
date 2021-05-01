# frozen_string_literal: true

module NameCompany
  def set_name_company(name)
    self.name = name
  end

  def show_name_company
    name
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
    # Тут перехватываем исключение, отображаем ошибку
    def validate
      validate!
    rescue RuntimeError => e
      puts e.message # Отображаем только сообщение пользователю
    end

    # Используется в файле main.rb. Если исключение, то сообщение об успешном создании объекта не отображается.
    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
