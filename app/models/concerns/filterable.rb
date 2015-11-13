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
    def render_attrs(args)
      self.serialize_options = {:only => [], :methods => args}
    end

    def public_scope(name, s)
      scope(name, s)
      self.public_scopes.push(name)
    end

    def filter!(params)
      res = self.scoped
      params.each do |key, value|
        if self.public_scopes.include?(key.so_sym)
          res = res.send(key, value)
        end
      end
      res
    end
  end
end
