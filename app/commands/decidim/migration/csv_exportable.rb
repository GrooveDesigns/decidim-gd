module Decidim
  module Migration
    module CsvExportable
      def export_csv
        csv_export = CSV.generate do |csv|
          csv << headers
          resources.each do |u|
            csv << parse_from(u)
          end
        end

        File.open(Rails.root.join(export_path), 'w') do |file|
          file.write(csv_export)
        end
      end

      private

      def export_path
        raise NotImplementedError
      end

      def parse_from(user)
        raise NotImplementedError
      end

      def headers
        raise NotImplementedError
      end

      def resources
        raise NotImplementedError
      end

      def unique_users
        @users.reduce([]) do |users, user|
          users << Decidim::Migration::User.create(user) unless users.any? { |u| u.email === user.email }
          users
        end
      end

      def find_unique_user(user)
        unique_users.find { |u| u.email === user.email }
      end

      def proposals(organization_ids)
        proposals = Decidim::Proposals::Proposal.all
        proposals.filter do |p|
          organization_ids.include?(p.organization.id)
        end
      end
    end
  end
end