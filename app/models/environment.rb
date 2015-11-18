class Environment < ActiveRecord::Base
  include Filterable
  DEFAULT_NAME = 'default'

  render_attrs :id, :name, :config, :created_at, :updated_at

# Associations
# ------------------------------------------------------------------------------
#
  has_ancestry
  has_many :variables, :dependent => :destroy
  has_and_belongs_to_many :users

# Scopes
# ------------------------------------------------------------------------------
#
  public_scope :user_id, -> (arg) {
    joins(:users).where(:users => {:id => arg})
  }

# Methods
# ------------------------------------------------------------------------------
#
  def self.find_by_slug!(slug)
    where(:name => slug).first or raise(
      # Error message for `where().first!` is too low-level, use a custom one
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

  # Compact version of the relation inherited_variables
  def config
    hash = {}
    inherited_variables.each do |var|
      hash[var.key] = var.value
    end
    hash
  end
end
