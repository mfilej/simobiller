require 'activesupport'
require 'action_view/helpers/text_helper'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'simobiller'

class Invoices < Thor

  include ActionView::Helpers::TextHelper

  desc 'import', 'imports data from xml files into the database'
  method_options :'source-dir' => :optional
  def import
    source = options[:source] || 'data'
    path = File.join(File.dirname(__FILE__), '..', source, '*.xml')

    files = Dir[path]
    puts "Found #{files.size} files in #{path}"
    
    files.each do |source|
      filename = File.basename(source)
      if Invoice.exists? :filename => filename
        puts "[SKIPPED] already imported #{filename}"
        next
      end
      
      Invoice.transaction do
        invoice = Invoice.create :filename => filename
        Parser::Invoice.new(open(source)).entries.each do |entry|
          invoice.entries.create entry.attributes
        end
        puts "[IMPORTED] #{filename} (#{pluralize(invoice.entries.size, 'entries')})"        
      end
    end
  end

end