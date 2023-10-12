class AddColumnRealNameAtDecidimUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :real_name, :string, null: false, default: 'default real name'
  end
end
