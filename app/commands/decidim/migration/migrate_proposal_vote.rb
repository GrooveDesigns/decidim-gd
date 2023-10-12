module Decidim
  module Migration
    class MigrateProposalVote
      include Decidim::Migration::CsvExportable

      class Vote
        attr_reader :user_id, :proposal_id

        def initialize(params)
          @user_id = params[:user_id]
          @proposal_id = params[:proposal_id]
        end
      end

      def initialize(organization_ids)
        @proposals = proposals(organization_ids)
        @users ||= Decidim::User.not_deleted.confirmed.where(decidim_organization_id: organization_ids).order(id: :asc)
      end

      private

      def export_path
        'csv/proposal_vote.csv'
      end

      def headers
        %w[user_id proposal_id]
      end

      def parse_from(vote)
        [vote.user_id, vote.proposal_id]
      end

      def resources
        @proposals.flat_map(&:votes).sort_by do |vote|
          [vote.decidim_author_id, vote.decidim_proposal_id]
        end.map do |vote|
          Decidim::Migration::MigrateProposalVote::Vote.new(
            user_id: find_unique_user(vote.author)&.id,
            proposal_id: vote.decidim_proposal_id,
          )
        end.filter do |vote|
          vote.user_id.present?
        end
      end
    end
  end
end