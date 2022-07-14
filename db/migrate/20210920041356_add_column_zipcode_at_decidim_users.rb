class AddColumnZipcodeAtDecidimUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :zipcode, :string, null: false, default: '1234567'
  end
end
