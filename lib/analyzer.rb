require 'rubygems'

require 'activerecord'
require 'db/config'

require 'invoice'


ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[:default])