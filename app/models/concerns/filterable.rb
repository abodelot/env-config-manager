module Filterable
  extend ActiveSupport::Concern

  included do
    class_attribute :serialize_options, :public_scopes
    self.public_scopes = []
  end

  def serializable_hash(options = {})
    super(self.serialize_options)
  end

  module ClassMethods

    # Generate options for the `serialize_options` method
    def render_attrs(*args)
      self.serialize_options = {:only => [], :methods => args}
    end

    # Declare a scope and make it available through API
    def public_scope(name, function)
      scope(name, function)
      self.public_scopes.push(name)
    end

    # Apply public scopes contained in params
    def filter!(params)
      res = self.all
      params.each do |key, value|
        if self.public_scopes.include?(key.to_sym)
          res = res.send(key, value)
        end
      end
      res
    end
  end
end
