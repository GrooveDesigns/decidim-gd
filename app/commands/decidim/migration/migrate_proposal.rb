module Decidim
  module Migration
    class MigrateProposal
      include Decidim::Migration::CsvExportable

      def initialize(organization_ids)
        @organization_ids = organization_ids
      end

      private

      def export_path
        'csv/proposal.csv'
      end

      def parse_from(proposal)
        [proposal.id, proposal.published_at]
      end

      def headers
        %w[proposal_id published_at]
      end

      def resources
        Decidim::Proposals::Proposal.published.order(:id).select do |p|
          @organization_ids.include?(p.organization.id)
        end
      end
    end
  end
end