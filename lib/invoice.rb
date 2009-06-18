class Invoice < ActiveRecord::Base
  has_many :entries
  
  def date
    if matches = filename.match(/specifikacija_(\d\d)(\d\d)(\d\d)/)
      year, month, day = matches.to_a[1..-1]
      Date.civil("20#{year}".to_i, month.to_i, day.to_i)
    end
  end
  
end