class AddColumnAcceptedPrivacyPolicyVersionClumnToDecidimUser < ActiveRecord::Migration[6.0]
  def up
    add_column :decidim_users, :accepted_privacy_policy_version, :datetime
  end

  def down
    remove_column :decidim_users, :accepted_privacy_policy_version, :datetime
  end
end
