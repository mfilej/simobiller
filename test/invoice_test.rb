require 'test_helper'

class InvoiceTest < Test::Unit::TestCase
  
  def test_assigns_date_from_filename
    invoice = Invoice.create! :filename => "specifikacija_0806228831006_031885658.xml"
    invoice.date.to_s(:db).should == "2008-06-22"
  end
  
end