module Decidim
  module Migration
    class MigrateParticipant
      include Decidim::Migration::CsvExportable

      def initialize(organization_ids)
        @users ||= Decidim::User.not_deleted.confirmed.where(decidim_organization_id: organization_ids).order(id: :asc)
      end

      private

      def export_path
        'csv/participant.csv'
      end

      def parse_from(user)
        [user.id, user.organization_id]
      end

      def headers
        %w[user_id organization_id]
      end

      def resources
        @users.sort_by do |u|
          [u.id, u.decidim_organization_id]
        end.map do |u|
          Decidim::Migration::User.create(u)
        end
      end
    end
  end
end
