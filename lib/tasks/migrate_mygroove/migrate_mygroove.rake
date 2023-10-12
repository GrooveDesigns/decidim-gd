namespace :migrate_mygroove do
  desc 'mygrooveへのマイグレーション用のcsv出力タスク'
  task :export_csv => :environment do
    yml = YAML.load_file(Rails.root.join('lib/tasks/migrate_mygroove/organization_ids.yml'))
    organization_ids = yml['organization_ids']
    pending_organization_ids = yml['pending_organization_ids']
    migrate_user = Decidim::Migration::MigrateUser.new(organization_ids)
    migrate_user.export_csv
    migrate_participant = Decidim::Migration::MigrateParticipant.new(organization_ids)
    migrate_participant.export_csv
    migrate_comment = Decidim::Migration::MigrateComment.new(organization_ids, pending_organization_ids)
    migrate_comment.export_csv
    migrate_vote = Decidim::Migration::MigrateProposalVote.new(organization_ids)
    migrate_vote.export_csv
    migrate_not_login_vote = Decidim::Migration::MigrateProposalNotLoginVote.new(organization_ids)
    migrate_not_login_vote.export_csv
    migrate_proposal = Decidim::Migration::MigrateProposal.new(organization_ids)
    migrate_proposal.export_csv
  end
end
