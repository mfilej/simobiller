require 'activerecord'
require 'db/config'

class Db < Thor

  desc 'reset database', 'drops, creates. and migrates the database'
  def reset
    %w(drop create migrate).each do |task|
      Db.start([task])
    end
  end

  desc 'create', 'creates the sqlite database file'
  def create
    if File.exist?(config['database'])
      $stderr.puts "#{config['database']} already exists"
    else
      begin
        # Create the SQLite database
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection
        puts "Successfuly created database file: #{config['database']}"
      rescue
        $stderr.puts $!, *($!.backtrace)
        $stderr.puts "Couldn't create database for #{config.inspect}"
      end
    end
  end

  desc 'migrate', 'migrates the database'
  method_options :version => :optional
  def migrate
    load_environment
    ActiveRecord::Migrator.migrate('db/migrate', options[:version] ? options[:version].to_i : nil)
  end

  desc 'drop', 'removes the sqlite database file'
  def drop
    if system %(rm #{config['database']})
      puts "Successfuly removed database file: #{config['database']}"
    end
  end
  
  private

  def config
    ActiveRecord::Base.configurations[:default]
  end

  def load_environment
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[:default])
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))        
  end
  
end