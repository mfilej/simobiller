class AddDateToInvoices < ActiveRecord::Migration  
  def self.up
    add_column :invoices, :date, :date
    
    Invoice.reset_column_information
    
    Invoice.find_each do |invoice|
      invoice.date = invoice.send(:parse_date_from_filename)
      invoice.save!
    end
  end
  
  def self.down
    remove_column :invoices, :date
  end
end