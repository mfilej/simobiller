require 'nokogiri'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'analyzer'

class Invoices < Thor

  desc 'import xml data', 'imports data from xml files in the into the database'
  method_options :source => :optional
  def import
    source = options[:source] || 'data'
    path = File.join(File.dirname(__FILE__), '..', source, '*.xml')

    Dir[path].each do |source|
      invoice = Invoice.create :filename => File.basename(source)
      Parser::Invoice.new(open(source)).entries.each do |entry|
        invoice.entries.create entry.attributes
      end
      
    end
  end

end