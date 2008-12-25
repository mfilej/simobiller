require 'rubygems'

require 'yaml'
require 'activerecord'


class Db < Thor

  def initialize
    load_config
  end

  desc 'create database', "creates the sqlite database file"
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

  desc 'migrate database', 'migrates the database (target specific version with VERSION=x)'
  def migrate
    load_environment
    ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
  end

  desc 'drop database', 'removes the sqlite database file'
  def drop
    if system %(rm #{config['database']})
      puts "Successfuly removed database file: #{config['database']}"
    end
  end
  
  private

  def load_config
    ActiveRecord::Base.configurations[:default] = {
      'adapter' => 'sqlite3',
      'database' => 'db/data.sqlite3'
    }
  end
  
  def config
    ActiveRecord::Base.configurations[:default]
  end

  def load_environment
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[:default])
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))        
  end
  
end