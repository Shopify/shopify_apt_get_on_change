actions :update

default_action :update if defined?(default_action)

attribute :base_name, name_attribute: true, kind_of: String, required: true
attribute :version, kind_of: String, required: true
attribute :datadog_event, kind_of: Hash, required: false, default: nil
