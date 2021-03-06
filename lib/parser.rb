require 'activesupport'

module Parser
  class Invoice
    def initialize(doc)
      @document = doc
      @xml = Hpricot.XML(@document)
    end
  
    def entries
      @entries = @xml.search('Zapis').map do |entry|
        Entry.new(entry)
      end
    end
  end

  class Entry
    def initialize(xml)
      @xml = xml
    end
    
    def attributes
      %w(happened_at description number operator duration amount).inject({}) do |hash, attr|
        hash[attr.intern] = send(attr)
        hash
      end
    end
    
    def happened_at
      year = 2008 # invoice.filename.split('_').second.first(2)
      day, month = @xml.at('Datum').inner_text.split('.')
      hours, minutes = @xml.at('Ura').inner_text.split(':')
      Time.mktime(year, month, day, hours, minutes)
    end
  
    def description
      @xml.at('Opis').inner_text
    end
  
    def number
      @xml.at('Stevilka').inner_text
    end
  
    def operator
      @xml.at('Operater').inner_text
    end
  
    def duration
      case dur = @xml.at('Trajanje').inner_text
      when /(\d{2}):(\d{2}):(\d{2})/
        hms_into_seconds($1, $2, $3)
      when /(\d+,\d+)([MK]B)/
        parse_into_bytes($1, $2)
      else
        raise %(Could not parse duration: #{dur}\nXML dump:\n#{@xml.to_s}\n)
      end
    end
  
    def amount
      @xml.at('EUR').inner_text.to_f
    end
    
    private
    
    def hms_into_seconds(h, m, s)
      h.to_i.hours + m.to_i.minutes + s.to_i
    end
    
    def parse_into_bytes(size, unit)
      size = size.tr(',','.').to_f
      case unit
      when 'MB' then size.megabytes
      when 'KB' then size.kilobytes
      end      
    end
  end
end