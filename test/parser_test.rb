require File.join(File.dirname(__FILE__), 'test_helper')

class ParserTest < Test::Unit::TestCase

  include Parser

  def test_should_detect_entries
    invoice = Invoice.new(source_for(:call, :data_kb, :data_mb))
    invoice.entries.size.should == 3
  end
  
  def test_should_detect_entry_time
    entry = Invoice.new(source_for(:call)).entries.first
    entry.happened_at.should == Time.mktime(2008, 11, 21, 07, 37)
  end
  
  def test_should_detect_entry_description
    entry = Invoice.new(source_for(:call)).entries.first
    entry.description.should == 'Klic v tujini'
  end
  
  def test_should_detect_number
    entry = Invoice.new(source_for(:call)).entries.first
    entry.number.should == '25081084730'
  end
  
  def test_should_detect_operator
    entry = Invoice.new(source_for(:call)).entries.first
    entry.operator.should == 'KENSA'
  end
  
  def test_should_detect_duration_in_seconds
    entry = Invoice.new(source_for(:call)).entries.first
    entry.duration.should == 88
  end
  
  def test_should_detect_duration_in_kilobytes
    entry = Invoice.new(source_for(:data_kb)).entries.first
    entry.duration.should == 354.62.kilobytes
  end
  
  def test_should_detect_duration_in_megabytes
    entry = Invoice.new(source_for(:data_mb)).entries.first
    entry.duration.should == 1.12.megabytes
  end
  
  def test_should_raise_for_unknown_duration
    entry = Invoice.new(source_for(:duration_unknown)).entries.first
    lambda do
      entry.duration
    end.should raise_error
  end
  
  def test_should_detect_amount
    entry = Invoice.new(source_for(:call)).entries.first
    entry.amount.should == 6.25
  end
  
  private
  
  def source_for(*entries)
    entries = (entries.first == :all ? Source::Entries.values : Source::Entries.values_at(*entries))
    Source::Invoice(entries)
  end
  
  module Source
    def self.Invoice(entries)
      <<INVOICE
<Specifikacija xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="si.simobil.billspecification.2.4" xsi:noNamespaceSchemaLocation="http://www.simobil.si/xml/BillSpecification_v2.3.xsd">
<Klicane_St.>
#{entries}
</Klicane_St.>
</Specifikacija>
INVOICE
    end
    
    Entries = { :call => <<"CALL", :data_mb => <<"DATA_MB", :data_kb => <<"DATA_KB", :duration_unknown => <<"DURATION_UNKNOWN" }
<Zapis>
<Datum>21.11.</Datum>
<Ura>07:37</Ura>
<Opis>Klic v tujini</Opis>
<Stevilka>25081084730</Stevilka>
<Operater>KENSA</Operater>
<Trajanje>00:01:28</Trajanje>
<EUR>000006.2500</EUR>
</Zapis>
CALL
<Zapis>
<Datum>21.11.</Datum>
<Ura>07:48</Ura>
<Opis>Prenos podatkov</Opis>
<Stevilka>INTERNET.SIMOBIL.SI</Stevilka>
<Operater>SVNSM</Operater>
<Trajanje>1,12MB</Trajanje>
<EUR>000000.3167</EUR>
</Zapis>
DATA_MB
<Zapis>
<Datum>16.12.</Datum>
<Ura>15:22</Ura>
<Opis>Prenos podatkov</Opis>
<Stevilka>INTERNET.SIMOBIL.SI</Stevilka>
<Operater>SVNSM</Operater>
<Trajanje>354,62KB</Trajanje>
<EUR>000000.1200</EUR>
</Zapis>
DATA_KB
<Zapis>
<Datum>16.12.</Datum>
<Ura>15:22</Ura>
<Opis>Prenos podatkov</Opis>
<Stevilka>INTERNET.SIMOBIL.SI</Stevilka>
<Operater>SVNSM</Operater>
<Trajanje>FOO!</Trajanje>
<EUR>000000.1200</EUR>
</Zapis>
DURATION_UNKNOWN
  end

end