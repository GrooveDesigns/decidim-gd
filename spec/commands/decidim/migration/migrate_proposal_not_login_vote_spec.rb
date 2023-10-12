require 'rails_helper'

RSpec.describe Decidim::Migration::MigrateProposalNotLoginVote, type: :command do
  let!(:organization1) { create :organization }
  let!(:organization2) { create :organization }
  let(:email1) { 'example1@email.com' }
  let(:email2) { 'example2@email.com' }
  let!(:email1_organization1_user) { create :user, organization: organization1, email: email1, privacy_policy_agreement: true, confirmed_at: Time.zone.now }
  let!(:email1_organization2_user) { create :user, organization: organization2, email: email1, privacy_policy_agreement: true, confirmed_at: Time.zone.now }
  let!(:organization1_participatory_space) { create :participatory_process, organization: organization1 }
  let!(:organization2_participatory_space) { create :participatory_process, organization: organization2 }
  let!(:organization1_component) { create :proposal_component, participatory_space: organization1_participatory_space }
  let!(:organization2_component) { create :proposal_component, participatory_space: organization2_participatory_space }
  let!(:organization1_proposal) { create :proposal, component: organization1_component, users: [email1_organization1_user], proposal_no_login_votes_count: 2 }
  let!(:organization2_proposal) { create :proposal, component: organization2_component, users: [email1_organization2_user], proposal_no_login_votes_count: 1 }

  describe 'private_methods' do
    describe 'resources' do
      describe 'organization1, 2共に含む場合' do
        let(:m) { described_class.new([organization1.id.to_s, organization2.id.to_s]) }

        it do
          resources = m.send(:resources)
          expect(resources.map { |u| m.send(:parse_from, u) }).to eq [
                                                                       [Digest::SHA256.hexdigest("proposal-#{organization1_proposal.id}-vote-index-0"), organization1_proposal.id],
                                                                       [Digest::SHA256.hexdigest("proposal-#{organization1_proposal.id}-vote-index-1"), organization1_proposal.id],
                                                                       [Digest::SHA256.hexdigest("proposal-#{organization2_proposal.id}-vote-index-0"), organization2_proposal.id],
                                                                     ]
        end
      end

      describe 'organization1のみの場合' do
        let(:m) { described_class.new([organization1.id.to_s]) }
        it do
          resources = m.send(:resources)
          expect(resources.map { |u| m.send(:parse_from, u) }).to eq [
                                                                       [Digest::SHA256.hexdigest("proposal-#{organization1_proposal.id}-vote-index-0"), organization1_proposal.id],
                                                                       [Digest::SHA256.hexdigest("proposal-#{organization1_proposal.id}-vote-index-1"), organization1_proposal.id],
                                                                     ]
        end
      end
    end
  end
end
