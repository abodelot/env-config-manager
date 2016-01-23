class Environment < ActiveRecord::Base
  include Filterable
  DEFAULT_SEPARATOR = '/'
  DEFAULT_SLUG_SEPARATOR = "+"

  render_attrs :id, :name, :vars, :created_at, :updated_at

  has_ancestry
  has_many :variables, :dependent => :destroy
  has_and_belongs_to_many :users

  validates :name, :presence => true, uniqueness: true

  ## Scopes

  public_scope :user_id, -> (arg) {
    joins(:users).where(users: {id: arg})
  }

  public_scope :slug, -> (arg) {
    arg = add_root(arg)
    slug = arg.split(DEFAULT_SLUG_SEPARATOR).join(DEFAULT_SEPARATOR)
    where(name: slug)
  }

  def self.add_root(name)
    if name[0] != DEFAULT_SEPARATOR
      name = "#{DEFAULT_SEPARATOR}#{name}"
    end
    return name
  end

  def self.find_by_name_or_id!(val)
    self.find_by_name_or_id(val) or raise(ActiveRecord::RecordNotFound.new("Couldn't find environment with name #{val}"))
  end

  def self.find_by_name_or_id(val)
    self.where(id: val.to_i).first or self.slug(val).first
  end

  def create_vars(hash={})
    hash.each do |key, value|
      var = Variable.where(:environment => self, :key => key).first_or_initialize
      var.value = value
      var.save!
    end
  end

  def self.split_name(name)
    name = add_root(name)
    name.split(DEFAULT_SEPARATOR)[1..-1]
  end

  def self.create_from_path(path, user=nil)
    tree = split_name(path)
    envs = []
    Environment.transaction do
      prev = nil
      current_path = ""
      tree.each do |name|
        current_path += "/#{name}"
        env = Environment.find_or_initialize_by(name: current_path)
        env.parent = prev
        if env.id.nil? && user != nil
          env.users << user
        end
        env.save!
        prev = env
        envs << env
      end
    end
    User.update_envs
    return envs
  end


  def update_path(newpath, user=nil)
    old_path = self.name
    Environment.transaction do
      self.name = self.class.add_root(newpath)
      self.save!
      self.children.each do |child|
        child.update_attribute(:name, child.name.gsub(old_path, newpath))
      end
      envs = Environment.create_from_path(newpath, user)
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

  def vars_text
    s = ""
    vars.each do |k,v|
      s += "#{k}='#{v}'\n"
    end
    return s
  end

  def vars
    inherited_variables(true)
  end

  def to_param
    name.gsub(DEFAULT_SEPARATOR, DEFAULT_SLUG_SEPARATOR)[1..-1]
  end


end
