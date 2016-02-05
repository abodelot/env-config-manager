class Environment < ActiveRecord::Base
  include Filterable
  extend FriendlyId

  friendly_id :name, :use => :slugged

  DEFAULT_NAME = 'root'

  render_attrs :id, :name, :vars, :created_at, :updated_at

  ## Relations

  has_ancestry
  has_many :variables, :dependent => :destroy
  has_and_belongs_to_many :users

  validates :name, :presence => true

  ## Scopes

  public_scope :user_id, -> (arg) {
    joins(:users).where(users: {id: arg})
  }

  ## Methods

  def create_vars(hash={})
    hash.each do |key, value|
      var = Variable.where(:environment => self, :key => key).first_or_initialize
      var.value = value
      var.save!
    end
  end

  def inherited_variables(as_hash=false)
    hash = {}
    array = []
    variables.all.each{|kv| hash[kv.key] = kv.value}
    array += variables
    p = self.parent
    while !p.nil?
      p.variables.each do |kv|
        if !hash.has_key?(kv.key)
          hash[kv.key] = kv.value
          array << kv
        end
      end
      p = p.parent
    end
    if as_hash
      return hash
    else
      return array
    end
  end

  def vars
    inherited_variables(true)
  end

  # Regenerate slug on name is updated
  def should_generate_new_friendly_id?
    name_changed?
  end
end
