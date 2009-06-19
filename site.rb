$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'simobiller'

require 'sinatra/base'
require 'map_by_method'

class Simobiller::Site < Sinatra::Base

  get '/' do
    haml :site, :locals => {
      :invoices => invoices,
      :entries => entries_by_sum,
      :current_invoices => current_invoices
    }
  end
  
  helpers do
    def toggle_invoice_ids(invoice)
      set = current_invoices.to_set
      if set.include?(invoice)
        set.delete(invoice)
      else
        set.add(invoice)
      end
      
      set.map(&:id).join(',')
    end
  end
  
  protected
  
  def current_invoices
    @invoices ||= if params[:ids]
      Invoice.find(params[:ids].split(','))
    else
      invoices
    end
  end
  
  def invoices
    Invoice.recent
  end
  
  def entries_by_sum
    Entry.sum(:amount, :conditions => { :invoice_id => current_invoices.map(&:id) },
      :group => 'number', :order => 'sum_amount desc')
  end
  
end
