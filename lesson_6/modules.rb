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