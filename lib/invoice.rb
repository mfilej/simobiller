class Invoice < ActiveRecord::Base
  
  attr_protected :date
  
  has_many :entries
  
  named_scope :recent, :order => 'date desc'
  
  before_create :assign_date
  
  protected
  
  def assign_date
    self.date = parse_date_from_filename
  end
  
  def parse_date_from_filename
    if matches = filename.match(/specifikacija_(\d\d)(\d\d)(\d\d)/)
      year, month, day = matches.to_a[1..-1]
      Date.civil("20#{year}".to_i, month.to_i, day.to_i)
    end
  end
  
end