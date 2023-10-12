module Decidim
  module Migration
    class MigrateUser
      include Decidim::Migration::CsvExportable

      def initialize(organization_ids)
        @users ||= Decidim::User.not_deleted.confirmed.where(decidim_organization_id: organization_ids).order(id: :asc)
      end

      private

      def export_path
        'csv/user.csv'
      end

      def parse_from(user)
        [user.id, user.email, user.nickname, user.real_name, user.zipcode, user.birth_year, user.email_on_notification]
      end

      def headers
        %w[user_id email nickname real_name zipcode birth_year email_on_notification]
      end

      def resources
        unique_users
      end
    end
  end
end