namespace :version do
  namespace :bump do
    VERSION_FILENAME = Rails.root.join('config', 'initializers', 'version.rb')

    def version_string
      "#{APP_VERSION[:major]}.#{APP_VERSION[:minor]}.#{APP_VERSION[:patch]}"
    end

    def save_version_file
      File.open(VERSION_FILENAME, 'w') do |file|
        file.write("APP_VERSION = #{APP_VERSION.to_s}")
      end
      Rake::Task['version:show'].invoke
    end

    desc 'Bump to next major version'
    task :major => :environment do
      APP_VERSION[:major] += 1
      APP_VERSION[:minor] = 0
      APP_VERSION[:patch] = 0
      save_version_file
    end

    desc 'Bump to next minor version'
    task :minor => :environment do
      APP_VERSION[:minor] += 1
      APP_VERSION[:patch] = 0
      save_version_file
    end

    desc 'Bump to next patch version'
    task :patch => :environment do
      APP_VERSION[:patch] += 1
      save_version_file
    end
  end

  desc 'Print current version'
  task :show => :environment do
    puts version_string
  end

  desc 'Initialize version'
  task :init => :environment do
    APP_VERSION[:major] = 1
    APP_VERSION[:minor] = 0
    APP_VERSION[:patch] = 0
    save_version_file
  end

  desc 'Perform git commit and git tag'
  task :release => :environment do
    puts "Are you sure to release version #{version_string}?"
    print '>> '
    if STDIN.gets.chomp.downcase[0] == 'y'
      system("git commit -m \"Release #{version_string}\"")
      system("git tag v#{version_string}")
      puts "#{version_string} released"
    else
      puts "#{version_string} release canceled."
    end
  end
end
