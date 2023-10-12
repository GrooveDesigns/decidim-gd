module Decidim
  module Migration
    class Comment
      attr_reader :id, :user_id, :commentable_id, :body, :created_at, :updated_at, :deleted_at, :migrate_pending_flag

      def initialize(**params)
        @id = params[:id]
        @user_id = params[:user_id]
        @commentable_id = params[:commentable_id]
        @body = params[:body]
        @created_at = params[:created_at]
        @updated_at = params[:updated_at]
        @deleted_at = params[:deleted_at]
        @migrate_pending_flag = params[:migrate_pending_flag]
      end

      def to_a
        [id, user_id, commentable_id, body, created_at, updated_at, deleted_at, migrate_pending_flag]
      end
    end

    class MigrateComment
      include Decidim::Migration::CsvExportable

      def initialize(organization_ids, pending_organization_ids)
        @comments = comments(organization_ids)
        @pending_organization_ids = pending_organization_ids
        @users ||= Decidim::User.not_deleted.confirmed.where(decidim_organization_id: organization_ids).order(id: :asc)
      end

      private

      def export_path
        'csv/comment.csv'
      end

      def headers
        %w[id user_id commentable_id body created_at updated_at deleted_at migrate_pending_flag]
      end

      def parse_from(comment)
        comment.to_a
      end

      def resources
        @comments.map do |comment|
          user_id = find_unique_user(comment.author)&.id
          next if user_id.blank?

          body = if comment.depth > 0
                   parent_comment = @comments.find { |c| c.id === comment.decidim_commentable_id }
                   "#{comment.body['ja']}\r\n\r\n> #{parent_comment.body['ja']}"
                 else
                   comment.body['ja']
                 end
          migrate_pending_flag = @pending_organization_ids.include?(comment.organization.id)
          Decidim::Migration::Comment.new(id: comment.id, user_id: user_id, commentable_id: comment.decidim_root_commentable_id, body: body, created_at: comment.created_at.to_s, updated_at: comment.updated_at.to_s, deleted_at: comment.deleted_at.to_s, migrate_pending_flag: migrate_pending_flag)
        end.compact.sort_by do |comment|
          comment.id
        end
      end

      def comments(organization_ids)
        comments = Decidim::Comments::Comment.all
        comments.filter do |comment|
          organization_ids.include?(comment.organization.id)
        end
      end
    end
  end
end