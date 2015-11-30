# Create default environment
e = Environment.where(:name => 'default').first_or_create

# Popuplate default env with some variables
e.create_vars({
  'CACHE_ENABLED': 'true',
  'I18N_DEFAULT': 'en',
  'VARIABLE_A': 'foobar',
  'VARIABLE_B': 'foobaz',
  'VARIABLE_C': 'barbaz',
})

# Helper for creating a base env with a list of sub envs
def create_app(basename, env_list)
  root_env = Environment.where(:name => 'default').first_or_create
  base_env = Environment.where(:name => basename).first_or_create
  base_env.parent = root_env
  base_env.save!

  env_list.each do |name|
    e = Environment.where(:name => basename + '-' + name).first_or_create
    e.parent = base_env
    e.save!
  end
  puts "Created environments for #{basename}"
end

# Create some environments
create_app('tf1', ['dev', 'qa', 'staging', 'prod'])
create_app('elisa', ['dev', 'staging', 'preprod', 'prod'])

# Create admin account
admin = User.new
admin.email = 'admin@email.com'
admin.password = 'adminvarager'
admin.password_confirmation = 'adminvarager'
admin.save!

admin.environments = Environment.all
