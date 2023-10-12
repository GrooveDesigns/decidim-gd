require 'rails_helper'

RSpec.describe Decidim::Migration::MigrateComment, type: :command do
  let!(:organization1) { create :organization }
  let!(:organization2) { create :organization }
  let(:email1) { 'example1@email.com' }
  let(:email2) { 'example2@email.com' }
  let(:email3) { 'example3@email.com' }
  let(:email_unconfirmed) { 'example-unconfirmed@email.com' }
  let(:email_deleted) { 'example-deleted@email.com' }
  let!(:email1_organization1_user) { create :user, organization: organization1, email: email1, privacy_policy_agreement: true, confirmed_at: Time.zone.now }
  let!(:email1_organization2_user) { create :user, organization: organization2, email: email1, privacy_policy_agreement: true, confirmed_at: Time.zone.now }
  let!(:email2_organization1_user) { create :user, organization: organization1, email: email2, privacy_policy_agreement: true, confirmed_at: Time.zone.now }
  let!(:email3_organization2_user) { create :user, organization: organization2, email: email3, privacy_policy_agreement: true, confirmed_at: Time.zone.now }
  let!(:unconfirmed_user) { create :user, organization: organization1, email: email_unconfirmed, privacy_policy_agreement: true, confirmed_at: nil }
  let!(:deleted_user) { create :user, organization: organization1, email: email_deleted, privacy_policy_agreement: true, confirmed_at: Time.zone.now, deleted_at: Time.zone.now }
  let!(:organization1_participatory_space) { create :participatory_process, organization: organization1 }
  let!(:organization2_participatory_space) { create :participatory_process, organization: organization2 }
  let!(:organization1_component) { create :proposal_component, participatory_space: organization1_participatory_space }
  let!(:organization2_component) { create :proposal_component, participatory_space: organization2_participatory_space }
  let!(:organization1_proposal) { create :proposal, component: organization1_component, users: [email1_organization1_user] }
  let!(:organization2_proposal) { create :proposal, component: organization2_component, users: [email1_organization2_user] }
  let!(:comment1) { create :comment, commentable: organization1_proposal, author: email1_organization1_user, body: 'comment1' }
  let!(:comment2) { create :comment, commentable: organization2_proposal, author: email1_organization2_user, body: 'comment2' }
  let!(:comment3) { create :comment, commentable: organization1_proposal, author: email2_organization1_user, body: 'comment3' }
  let!(:comment4) { create :comment, commentable: organization2_proposal, author: email3_organization2_user, body: 'comment4' }
  let!(:comment5) { create :comment, commentable: comment1, root_commentable: organization1_proposal, author: email1_organization1_user, body: 'comment5' }
  let!(:comment6) { create :comment, commentable: comment5, root_commentable: organization1_proposal, author: email1_organization1_user, body: 'comment6' }
  let!(:comment7) { create :comment, commentable: organization1_proposal, author: deleted_user, body: 'deleted' }

  describe 'private_methods' do
    describe 'resources' do
      describe 'organization1, 2共に含む場合' do
        let(:m) { described_class.new([organization1.id.to_s, organization2.id.to_s]) }

        it do
          resources = m.send(:resources)
          expect(resources.map { |u|
            m.send(:parse_from, u)
          }).to eq [
                     [comment1.id, Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id, 'comment1', comment1.created_at.to_s, comment1.updated_at.to_s, comment1.deleted_at.to_s],
                     [comment2.id, Digest::SHA256.hexdigest(email1_organization1_user.email), organization2_proposal.id, 'comment2', comment2.created_at.to_s, comment2.updated_at.to_s, comment2.deleted_at.to_s],
                     [comment3.id, Digest::SHA256.hexdigest(email2_organization1_user.email), organization1_proposal.id, 'comment3', comment3.created_at.to_s, comment3.updated_at.to_s, comment3.deleted_at.to_s],
                     [comment4.id, Digest::SHA256.hexdigest(email3_organization2_user.email), organization2_proposal.id, 'comment4', comment4.created_at.to_s, comment4.updated_at.to_s, comment4.deleted_at.to_s],
                     [comment5.id, Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id, "comment5\r\n\r\n> comment1", comment5.created_at.to_s, comment5.updated_at.to_s, comment5.deleted_at.to_s],
                     [comment6.id, Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id, "comment6\r\n\r\n> comment5", comment6.created_at.to_s, comment6.updated_at.to_s, comment6.deleted_at.to_s],
                   ]
        end
      end

      describe 'organization1のみの場合' do
        let(:m) { described_class.new([organization1.id.to_s]) }
        it do
          resources = m.send(:resources)
          expect(resources.map { |u| m.send(:parse_from, u) }).to eq [
                                                                       [comment1.id, Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id, 'comment1', comment1.created_at.to_s, comment1.updated_at.to_s, comment1.deleted_at.to_s],
                                                                       [comment3.id, Digest::SHA256.hexdigest(email2_organization1_user.email), organization1_proposal.id, 'comment3', comment3.created_at.to_s, comment3.updated_at.to_s, comment3.deleted_at.to_s],
                                                                       [comment5.id, Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id, "comment5\r\n\r\n> comment1", comment5.created_at.to_s, comment5.updated_at.to_s, comment5.deleted_at.to_s],
                                                                       [comment6.id, Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id, "comment6\r\n\r\n> comment5", comment6.created_at.to_s, comment6.updated_at.to_s, comment6.deleted_at.to_s],
                                                                     ]
        end
      end
    end
  end
end
