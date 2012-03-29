require 'active_model/callbacks'
require 'active_model/mass_assignment_security'

class UrlKeyableModel
  extend ActiveModel::Callbacks
  include ActiveModel::MassAssignmentSecurity

  define_model_callbacks :create

  def initialize(attrs = {})
    @attributes = sanitize_for_mass_assignment(attrs)
  end

  def url_key
    @attributes[:url_key]
  end

  def read_attribute(key)
    @attributes[key]
  end

  def write_attribute(key, value)
    @attributes[key] = value
  end

  def save
    run_callbacks :create do
      #logic
    end
  end
end
