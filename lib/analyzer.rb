require 'rubygems'

require 'activerecord'
require 'db/config'

require 'invoice'
require 'entry'
require 'parser'


ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[:default])
