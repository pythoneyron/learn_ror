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

module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        history_name = "#{name}_history"
        var_name = "@#{name}".to_sym
        var_history_name = "#{var_name}_history"

        define_method(name) { instance_variable_get(var_name) }
        define_method(history_name) { instance_variable_get(var_history_name) }

        define_method("#{name}=".to_sym) do |val|
          instance_variable_set(var_history_name, []) unless instance_variable_get(var_history_name)

          arr_history_name = instance_variable_get(var_history_name)

          arr_history_name << val unless arr_history_name.include?(val)
          instance_variable_set(var_name, val)
        end
      end
    end

    def strong_attr_accessor(name, type_class)
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |val|
        raise "Несоответствие типа присваемого значения. Ожидается: #{type_class}" if val.class != type_class

        instance_variable_set(var_name, val)
      end
    end
  end

  module InstanceMethods
  end
end

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr, type, *args)
      attr = attr.to_sym
      type = type.to_sym

      name = 'data_valid'
      var_name = "@#{name}"

      instance_variable_set(var_name, {}) unless instance_variable_get(var_name)
      data_valid = instance_variable_get(var_name)

      class << self ; attr_reader :data_valid end

      data_valid[attr] ||= { type => args }
      data_valid[attr].merge!( type => args )
    end
  end

  module InstanceMethods
    def validate!
      (self.class.data_valid || self.class.superclass.data_valid).each do |attr, data|
        val_attr = instance_variable_get("@#{attr}")

        if data.key?(:presence)
          raise "Атрибут '#{attr}' не может быть пустым или не определенным!" if val_attr.nil? || val_attr == 0 || val_attr == ''
        end

        if data.key?(:format)
          data[:format].each do |format|
            raise "Атрибут '#{attr}' со значением '#{val_attr}' не соответствует формату!" if val_attr !~ format
          end
        end

        if data.key?(:type)
          data[:type].each do |type|
            raise "Атрибут '#{attr}' со значением '#{val_attr}' не соответствует типу '#{type}'" if val_attr.class != type
          end
        end
      end
    rescue RuntimeError => e # Поставил специально для того, что бы не "валило" программу
      puts e.message
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
