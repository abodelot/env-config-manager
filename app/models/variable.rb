class Variable < ActiveRecord::Base
  belongs_to :environment

  validates :key, :presence => true, :uniqueness => { :scope => :environment_id }
  validates :environment, :presence => true
end
