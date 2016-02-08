class Environment < ActiveRecord::Base
  include Filterable
  DEFAULT_NAME = 'root'

  render_attrs :id, :name, :vars, :created_at, :updated_at

  has_ancestry
  has_many :variables, :dependent => :destroy
  has_and_belongs_to_many :users

  validates :name, :presence => true

  ## Scopes

  public_scope :user_id, -> (arg) {
    joins(:users).where(users: {id: arg})
  }

  def self.find_by_name_or_id!(val)
    self.find_by_name_or_id(val) or raise(ActiveRecord::RecordNotFound.new("Couldn't find environment with name #{val}"))
  end

  def self.find_by_name_or_id(val)
    self.where(id: val.to_i).first or self.find_by(name: val)
  end

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

  def to_param
    name
  end


end
