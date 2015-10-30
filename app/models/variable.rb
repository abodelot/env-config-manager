class Variable < ActiveRecord::Base

# Validations
# ------------------------------------------------------------------------------
#
  validates :key, :presence => true, :uniqueness => { :scope => :environment_id }
  validates :value, :presence => true
  validates :environment, :presence => true

# Associations
# ------------------------------------------------------------------------------
#
  belongs_to :environment
end
