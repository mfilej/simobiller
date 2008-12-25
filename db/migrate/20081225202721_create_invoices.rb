class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices, :force => true do |t|
      t.string :filename
      t.date :created_at
    end
  end
  
  def self.down
    drop_table :invoices
    add_index :invoices, :filename
  end
end