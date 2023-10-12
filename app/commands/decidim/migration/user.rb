module Decidim
  module Migration
    class User
      attr_reader :id, :email, :real_name, :nickname, :zipcode, :birth_year, :email_on_notification, :organization_id

      def initialize(params)
        @id = Digest::SHA256.hexdigest(params[:email])
        @email = params[:email]
        @real_name = params[:real_name]
        @nickname = params[:nickname]
        @zipcode = params[:zipcode]
        @birth_year = params[:birth_year]
        @email_on_notification = params[:email_on_notification]
        @organization_id = params[:organization_id]
      end

      class << self
        def create(user)
          self.new(
            email: user.email,
            nickname: user.nickname,
            real_name: user.real_name,
            zipcode: user.zipcode,
            birth_year: user.birth_year,
            email_on_notification: user.email_on_notification,
            organization_id: user.decidim_organization_id
          )
        end
      end
    end
  end
end
