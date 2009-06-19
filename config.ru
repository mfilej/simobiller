require 'rubygems'
require 'sinatra'
require 'site'

set :environment, ENV['RACK_ENV'].to_sym

run Simobiller::Site