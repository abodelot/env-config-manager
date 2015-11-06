class Environment < ActiveRecord::Base

# Associations
# ------------------------------------------------------------------------------
#
  has_ancestry
  has_many :variables

# Methods
# ------------------------------------------------------------------------------
#
  def self.find_by_slug!(slug)
    where(:name => slug).first or raise(
      ActiveRecord::RecordNotFound.new("Couldn't find environment with name #{slug}")
    )
  end

  def create_vars(hash)
    hash.each do |key, value|
      var = Variable.where(:environment => self, :key => key).first_or_initialize
      var.value = value
      var.save!
    end
  end

  def inherited_variables(array = self.variables.to_a)
    if !root?
      parent.variables.each do |var|
        if !array.detect { |i| i.key == var.key }
          array << var
        end
      end
      parent.inherited_variables(array)
    end
    array.sort_by(&:key)
  end

  # Generate urls with name instead of id
  def to_param
    name
  end

  # Serialize variables in object
  def as_json(options = nil)
    hash = super(options)
    variables = {}
    inherited_variables.each do |var|
      variables[var.key] = var.value
    end
    hash['variables'] = variables
    hash
  end
end
