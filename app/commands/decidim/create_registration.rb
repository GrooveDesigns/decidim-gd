module Decidim
  # A command with all the business logic to create a user through the sign up form.
  class CreateRegistration < Rectify::Command
    # Public: Initializes the command.
    #
    # form - A form object with the params.
    def initialize(form)
      @form = form
    end

    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid.
    # - :invalid if the form wasn't valid and we couldn't proceed.
    #
    # Returns nothing.
    def call
      if form.invalid?
        user = User.has_pending_invitations?(form.current_organization.id, form.email)
        user.invite!(user.invited_by) if user
        return broadcast(:invalid)
      end

      create_user

      broadcast(:ok, @user)
    # rescue ActiveRecord::RecordInvalid
    #   broadcast(:invalid)
    end

    private

    attr_reader :form

    def create_user
      @user = User.create!(
        email: form.email,
        name: form.name,
        real_name: form.real_name,
        nickname: form.nickname,
        password: form.password,
        password_confirmation: form.password_confirmation,
        organization: form.current_organization,
        tos_agreement: form.tos_agreement,
        privacy_policy_agreement: form.privacy_policy_agreement,
        newsletter_notifications_at: form.newsletter_at,
        email_on_notification: true,
        accepted_tos_version: form.current_organization.tos_version,
        accepted_privacy_policy_version: Time.current,
        zipcode: form.zipcode,
        birth_year: form.birth_year,
        locale: form.current_locale
      )
    end
  end
end
