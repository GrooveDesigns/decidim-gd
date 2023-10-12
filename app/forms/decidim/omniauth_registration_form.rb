# frozen_string_literal: true

module Decidim
  # A form object used to fisnish signup from omniauth data
  class OmniauthRegistrationForm < Form
    mimic :user

    attribute :name, String
    attribute :real_name, String
    attribute :email, String
    attribute :provider, String
    attribute :uid, String
    attribute :oauth_signature, String
    attribute :newsletter, Boolean
    attribute :tos_agreement, Boolean
    attribute :privacy_policy_agreement, Boolean
    attribute :current_locale, String
    attribute :raw_data, Hash
    attribute :zipcode, String
    attribute :birth_year, Integer
    attribute :avatar_url, String

    validates :name, presence: true
    validates :real_name, presence: true
    validates :email, presence: true
    validates :provider, presence: true
    validates :uid, presence: true
    validates :tos_agreement, allow_nil: false, acceptance: true
    validates :privacy_policy_agreement, allow_nil: false, acceptance: true
    validates :zipcode, presence: true, format: {with: /[0-9]{7}/}
    validates :birth_year, presence: true, numericality: { only_integer: true, greater_than: 0 }

    def self.create_signature(provider, uid)
      Digest::MD5.hexdigest("#{provider}-#{uid}-#{Rails.application.secrets.secret_key_base}")
    end

    def normalized_nickname
      # create nickname as unique account id
      SecureRandom.urlsafe_base64(8)
    end

    def newsletter_at
      return nil unless newsletter?

      Time.current
    end
  end
end