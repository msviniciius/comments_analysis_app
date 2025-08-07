class ReprocessAllCommentsJob < ApplicationJob
  queue_as :critical

  def perform
    Comment.find_each do |comment|
      ProcessCommentJob.perform_later(comment.id)
    end
  end
end
