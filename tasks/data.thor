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
      invoice = Invoice.create :filename = File.basename(source)
      xml = Nokogiri::XML(open(source))
      xml.xpath('/Specifikacija/Klicane_St./Zapis').each do |el|
        invoice.entries.build do |entry|
          entry.happened_at = begin
            year = invoice.filename.split('_').second.first(2)
            date = el.at('./Datum').content.split('.').reverse.unshift(year).join('-')
            Time.parse(date + ' ' + el.at('./Ura'))
          end
          entry.description = el.at('./Opis')
          entry.number = el.at('./Stevilka')
          entry.operator = el.at('./Operater')
          entry.duration = begin
            hms = el.at('./Trajanje').split(':')
            hms[0].hours + hms[1].minutes + hms[2].seconds 
          end
        end
      end
    end
  end
end