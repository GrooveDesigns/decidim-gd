# frozen_string_literal: true

module Decidim
  # A form object used to handle user registrations
  class RegistrationForm < Form
    mimic :user

    attribute :name, String
    attribute :real_name, String
    attribute :email, String
    attribute :password, String
    attribute :newsletter, Boolean
    attribute :tos_agreement, Boolean
    attribute :privacy_policy_agreement, Boolean
    attribute :current_locale, String
    attribute :zipcode, String
    attribute :birth_year, Integer
    attribute :password_display, Boolean

    validates :name, presence: true
    validates :real_name, presence: true
    validates :email, presence: true, 'valid_email_2/email': { disposable: true }
    validates :password, password: { name: :name, email: :email }
    validates :tos_agreement, allow_nil: false, acceptance: true
    validates :privacy_policy_agreement, allow_nil: false, acceptance: true
    validates :zipcode, presence: true, format: {with: /[0-9]{7}/}
    validates :birth_year, presence: true, numericality: { only_integer: true, greater_than: 0 }

    validate :email_unique_in_organization
    validate :no_pending_invitations_exist

    def nickname
      # create nickname as unique account id
      SecureRandom.urlsafe_base64(8)
    end

    def newsletter_at
      return nil unless newsletter?

      Time.current
    end

    def password_confirmation
      password
    end

    private

    def email_unique_in_organization
      errors.add :email, :taken if User.no_active_invitation.find_by(email: email, organization: current_organization).present?
    end

    def no_pending_invitations_exist
      errors.add :base, I18n.t("devise.failure.invited") if User.has_pending_invitations?(current_organization.id, email)
    end
  end
end
