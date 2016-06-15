actions :update

default_action :update if defined?(default_action)

attribute :base_name, name_attribute: true, kind_of: String, required: true
attribute :version, kind_of: String, required: true
