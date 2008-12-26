require 'activesupport'
require 'nokogiri'

module Parser
  class Invoice
    def initialize(doc)
      @document = doc
      @xml = Nokogiri::XML(@document)
    end
  
    def entries
      @entries = @xml.xpath('/Specifikacija/Klicane_St./Zapis').map do |entry|
        Entry.new(entry)
      end
    end
  end

  class Entry
    def initialize(xml)
      @xml = xml
    end
    
    def attributes
      %w(happened_at, description, number, operator, duration, amount).inject({}) do |hash, attr|
        hash[attr.intern] = send(attr)
      end
    end
    
    def happened_at
      year = 2008 # invoice.filename.split('_').second.first(2)
      day, month = @xml.at('./Datum').content.split('.')
      hours, minutes = @xml.at('./Ura').content.split(':')
      Time.mktime(year, month, day, hours, minutes)
    end
  
    def description
      @xml.at('./Opis').content
    end
  
    def number
      @xml.at('./Stevilka').content
    end
  
    def operator
      @xml.at('./Operater').content
    end
  
    def duration
      hms = @xml.at('./Trajanje').content.split(':').map(&:to_i)
      hms[0].hours + hms[1].minutes + hms[2].seconds
    end
  
    def amount
      @xml.at('./EUR').content.to_f
    end
  end
end