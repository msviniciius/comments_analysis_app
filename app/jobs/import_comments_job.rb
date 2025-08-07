class ImportCommentsJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    comments = JsonPlaceholderClient.fetch_comments(post.external_id)

    comments.each do |comment_data|
      comment = Comment.find_or_create_by!(
        external_id: comment_data["id"],
        post: post
      ) do |c|
        c.content = comment_data["body"]
        c.status = "new"
      end

      ProcessCommentJob.perform_later(comment.id)
    end
  end
end
