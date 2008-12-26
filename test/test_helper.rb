require 'test/unit'

require 'rubygems'
require 'matchy'

require '../lib/parser'

class ParserTest < Test::Unit::TestCase

  include Parser

  def test_should_find_entries
    entries = Invoice.new(fixtures[:entries]).entries
    assert_equal 3, entries.size
  end
  
  def test_should_find_entry_time
    entry = Invoice.new(fixtures[:entries]).entries.first
    assert_equal Time.mktime(2008, 11, 21, 07, 37), entry.happened_at
  end
  
  def test_should_find_entry_description
    entry = Invoice.new(fixtures[:entries]).entries.first
    assert_equal 'Klic v tujini', entry.description
  end
  
  def test_should_find_number
    entry = Invoice.new(fixtures[:entries]).entries.first
    assert_equal '25081084730', entry.number
  end
  
  def test_should_find_operator
    entry = Invoice.new(fixtures[:entries]).entries.first
    assert_equal 'KENSA', entry.operator
  end
  
  def test_should_find_duration_in_seconds
    entry = Invoice.new(fixtures[:entries]).entries.first
    assert_equal 88, entry.duration
  end
  
  def test_should_find_duration_in_kilobytes
    entry = Invoice.new(fixtures[:entries]).entries.last
    assert_equal 354.62.kilobytes, entry.duration
  end
  
  def test_should_find_amount
    entry = Invoice.new(fixtures[:entries]).entries.first
    assert_equal 6.25, entry.amount
  end
  
  private
  
  def fixtures
    { :entries => <<"EOS" }
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