require 'rails_helper'

RSpec.describe Decidim::Migration::MigrateProposalVote, type: :command do
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

  before do
    create :proposal_vote, proposal: organization1_proposal, author: email1_organization1_user
    create :proposal_vote, proposal: organization2_proposal, author: email1_organization2_user
    create :proposal_vote, proposal: organization1_proposal, author: email2_organization1_user
    create :proposal_vote, proposal: organization2_proposal, author: email3_organization2_user
    create :proposal_vote, proposal: organization1_proposal, author: deleted_user
  end

  describe 'private_methods' do
    describe 'resources' do
      describe 'organization1, 2共に含む場合' do
        let(:m) { described_class.new([organization1.id.to_s, organization2.id.to_s]) }

        it do
          resources = m.send(:resources)
          expect(resources.map { |u| m.send(:parse_from, u) }).to eq [
                                                                       [Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id],
                                                                       [Digest::SHA256.hexdigest(email1_organization1_user.email), organization2_proposal.id],
                                                                       [Digest::SHA256.hexdigest(email2_organization1_user.email), organization1_proposal.id],
                                                                       [Digest::SHA256.hexdigest(email3_organization2_user.email), organization2_proposal.id],
                                                                     ]
        end
      end

      describe 'organization1のみの場合' do
        let(:m) { described_class.new([organization1.id.to_s]) }
        it do
          resources = m.send(:resources)
          expect(resources.map { |u| m.send(:parse_from, u) }).to eq [
                                                                       [Digest::SHA256.hexdigest(email1_organization1_user.email), organization1_proposal.id],
                                                                       [Digest::SHA256.hexdigest(email2_organization1_user.email), organization1_proposal.id],
                                                                     ]
        end
      end
    end
  end
end
