class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries, :force => true do |t|
      t.references :invoice
      t.datetime :happened_at
      t.string :description, :number, :operator
      t.integer :duration
      t.decimal :amount, :precision => 5, :scale => 2
      t.timestamps
    end
    add_index :entries, :invoice_id
    add_index :entries, :number
    add_index :entries, :operator
  end

  def self.down
    drop_table :entries
  end
end
