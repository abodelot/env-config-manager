class Environment < ActiveRecord::Base

# Associations
# ------------------------------------------------------------------------------
#
  has_ancestry
  has_many :variables

  scope :find_by_slug, -> (slug) { where(:name => slug).first }

  def create_var(key, value)
    v = Variable.create!(
      :key => key,
      :value => value,
      :environment => self
    )
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
end
