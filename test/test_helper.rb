require 'rubygems'
# gem 'test-unit', '~> 2'
require 'test/unit'
# gem 'mocha'
require 'mocha'
# require 'builder'
  
require File.join( File.dirname(__FILE__), '..','lib', 'fax_finder.rb')

class Class
  def publicize_instance_methodss
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public(*saved_private_instance_methods) }
    yield
    self.class_eval { private(*saved_private_instance_methods) }
  end

  def publicize_class_methods
    saved_private_class_methods = self.private_methods(false)
    self.class_eval { public_class_method(*saved_private_class_methods) }
    yield
    self.class_eval { private_class_method(*saved_private_class_methods) }
  end
end