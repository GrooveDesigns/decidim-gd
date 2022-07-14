class AddColumnAgeAtDecidimUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :birth_year, :integer, null: false, default: 0
  end
end
