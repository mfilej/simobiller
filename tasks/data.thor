require 'nokogiri'
require 'activesupport'
require 'action_view/helpers/text_helper'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'analyzer'

class Invoices < Thor

  include ActionView::Helpers::TextHelper

  desc 'import xml data', 'imports data from xml files in the into the database'
  method_options :source => :optional
  def import
    source = options[:source] || 'data'
    path = File.join(File.dirname(__FILE__), '..', source, '*.xml')

    Dir[path].each do |source|
      filename = File.basename(source)
      if Invoice.exists? :filename => filename
        puts "[SKIPPED] already imported #{filename}"
        next
      end
      
      invoice = Invoice.create :filename => filename
      Parser::Invoice.new(open(source)).entries.each do |entry|
        invoice.entries.create entry.attributes
      end
      puts "[IMPORTED] #{filename} (#{pluralize(invoice.entries.size, 'entries')})"
    end
  end

end