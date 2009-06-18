require 'test_helper'

class InvoiceTest < Test::Unit::TestCase
  
  def test_should_parse_the_date_from_the_filename
    invoice = Invoice.new :filename => "specifikacija_0806228831006_031885658.xml"
    invoice.date.to_s(:db).should == "2008-06-22"
  end
  
end