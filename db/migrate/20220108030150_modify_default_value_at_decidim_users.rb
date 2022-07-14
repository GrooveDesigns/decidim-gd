class ModifyDefaultValueAtDecidimUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :decidim_users, :zipcode, :string, default: '123-4567', null: false
    change_column :decidim_users, :birth_year, :integer, default: 1, null: false
  end
end
