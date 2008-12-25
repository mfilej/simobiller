require 'rubygems'

require 'activerecord'
require 'db/config'

require 'invoice'
require 'entry'


ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[:default])
