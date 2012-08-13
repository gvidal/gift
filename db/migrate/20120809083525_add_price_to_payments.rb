class AddPriceToPayments < ActiveRecord::Migration
  def change
    add_column(:payments,:quantity,:float)
  end
end
