# frozen_string_literal: true

module Decidim
  module Proposals
    # Exposes the proposal vote resource so users can vote proposals.
    class ProposalVotesController < Decidim::Proposals::ApplicationController
      include ProposalVotesHelper
      include Decidim::CookiesHelper
      include Rectify::ControllerHelpers

      helper_method :proposal

      # enable nologin vote
      #before_action :authenticate_user!

      def create
        if current_user
          enforce_permission_to :vote, :proposal, proposal: proposal
        end

        @from_proposals_list = params[:from_proposals_list] == "true"

        if !current_user && cookies_accepted? && !already_nologin_voted?(proposal)
          proposal.increment_nologin_votes_count
          proposals = Proposal.where(component: current_component)
          create_nologin_vote(proposal)

          expose(proposals: proposals)
          render :update_buttons_and_counters and return
        end

        VoteProposal.call(proposal, current_user) do
          on(:ok) do
            proposal.reload

            proposals = ProposalVote.where(
              author: current_user,
              proposal: Proposal.where(component: current_component)
            ).map(&:proposal)

            expose(proposals: proposals)
            render :update_buttons_and_counters
          end

          on(:invalid) do
            render json: { error: I18n.t("proposal_votes.create.error", scope: "decidim.proposals") }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        if current_user
          enforce_permission_to :unvote, :proposal, proposal: proposal
        end

        @from_proposals_list = params[:from_proposals_list] == "true"

        if already_nologin_voted?(proposal)
          proposal.decrement_nologin_votes_count
          proposals = Proposal.where(component: current_component)
          destroy_nologin_vote(proposal)

          expose(proposals: proposals + [proposal])
          render :update_buttons_and_counters and return
        end

        UnvoteProposal.call(proposal, current_user) do
          on(:ok) do
            proposal.reload

            proposals = ProposalVote.where(
              author: current_user,
              proposal: Proposal.where(component: current_component)
            ).map(&:proposal)

            expose(proposals: proposals + [proposal])
            render :update_buttons_and_counters
          end
        end
      end

      private

      def proposal
        @proposal ||= Proposal.where(component: current_component).find(params[:proposal_id])
      end
    end
  end
end
