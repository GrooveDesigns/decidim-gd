class AddNoLoginVoteColumnToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_proposals_proposals, :proposal_no_login_votes_count, :integer, null: false, default: 0
  end
end
