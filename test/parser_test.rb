require File.join(File.dirname(__FILE__), 'test_helper')

require '../lib/parser'

class ParserTest < Test::Unit::TestCase

  include Parser

  def test_should_detect_entries
    invoice = Invoice.new(source)
    invoice.entries.size.should == 3
  end
  
  def test_should_detect_entry_time
    entry = Invoice.new(source).entries.first
    entry.happened_at.should == Time.mktime(2008, 11, 21, 07, 37)
  end
  
  def test_should_detect_entry_description
    entry = Invoice.new(source).entries.first
    entry.description.should == 'Klic v tujini'
  end
  
  def test_should_detect_number
    entry = Invoice.new(source).entries.first
    entry.number.should == '25081084730'
  end
  
  def test_should_detect_operator
    entry = Invoice.new(source).entries.first
    entry.operator.should == 'KENSA'
  end
  
  def test_should_detect_duration_in_seconds
    entry = Invoice.new(source).entries.first
    entry.duration.should == 88
  end
  
  def test_should_detect_duration_in_kilobytes
    entry = Invoice.new(source).entries.last
    entry.duration.should == 354.62.kilobytes
  end
  
  def test_should_detect_amount
    entry = Invoice.new(source).entries.first
    entry.amount.should == 6.25
  end
  
  private
  
  def source
    <<"EOS"
<Specifikacija xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="si.simobil.billspecification.2.4" xsi:noNamespaceSchemaLocation="http://www.simobil.si/xml/BillSpecification_v2.3.xsd">
<Klicane_St.>
<Zapis>
<Datum>21.11.</Datum>
<Ura>07:37</Ura>
<Opis>Klic v tujini</Opis>
<Stevilka>25081084730</Stevilka>
<Operater>KENSA</Operater>
<Trajanje>00:01:28</Trajanje>
<EUR>000006.2500</EUR>
</Zapis>
<Zapis>
<Datum>21.11.</Datum>
<Ura>07:48</Ura>
<Opis>SMS v tujini</Opis>
<Stevilka>38640441000</Stevilka>
<Operater>KENSA</Operater>
<Trajanje>00:00:00</Trajanje>
<EUR>000000.3167</EUR>
</Zapis>
<Zapis>
<Datum>16.12.</Datum>
<Ura>15:22</Ura>
<Opis>Prenos podatkov</Opis>
<Stevilka>INTERNET.SIMOBIL.SI</Stevilka>
<Operater>SVNSM</Operater>
<Trajanje>354,62KB</Trajanje>
<EUR>000000.1200</EUR>
</Zapis>
EOS
  end

end