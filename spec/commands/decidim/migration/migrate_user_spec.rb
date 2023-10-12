require 'rails_helper'

RSpec.describe Decidim::Migration::MigrateUser, type: :command do
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

  describe 'private_methods' do
    describe 'resources' do
      describe 'organization1, 2共に含む場合' do
        let(:m) { described_class.new([organization1.id.to_s, organization2.id.to_s]) }

        it do
          resources = m.send(:resources)
          expect(resources.map(&:id)).to eq [
                                              Digest::SHA256.hexdigest(email1_organization1_user.email),
                                              Digest::SHA256.hexdigest(email2_organization1_user.email),
                                              Digest::SHA256.hexdigest(email3_organization2_user.email),
                                            ]
        end
      end

      describe 'organization1のみの場合' do
        let(:m) { described_class.new([organization1.id.to_s]) }
        it do
          resources = m.send(:resources)
          expect(resources.map(&:id)).to eq [
                                              Digest::SHA256.hexdigest(email1_organization1_user.email),
                                              Digest::SHA256.hexdigest(email2_organization1_user.email),
                                            ]
        end
      end
    end
  end
end
