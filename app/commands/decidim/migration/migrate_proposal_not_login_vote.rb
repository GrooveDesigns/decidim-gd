module Decidim
  module Migration
    class NotLoginVote
      attr_reader :uuid, :proposal_id

      def initialize(uuid, proposal_id)
        @uuid = uuid
        @proposal_id = proposal_id
      end
    end

    class MigrateProposalNotLoginVote
      include Decidim::Migration::CsvExportable

      def initialize(organization_ids)
        @proposals = proposals(organization_ids)
      end

      private

      def export_path
        'csv/proposal_not_login_vote.csv'
      end

      def headers
        %w[uuid proposal_id]
      end

      def parse_from(vote)
        [vote.uuid, vote.proposal_id]
      end

      def resources
        @proposals.reduce([]) do |votes, proposal|
          proposal.proposal_no_login_votes_count.times do |i|
            uuid = Digest::SHA256.hexdigest("proposal-#{proposal.id}-vote-index-#{i}")
            votes << Decidim::Migration::NotLoginVote.new(uuid, proposal.id)
          end

          votes
        end.sort_by do |vote|
          vote.proposal_id
        end
      end
    end
  end
end