class CommentsController < ApplicationController
  def index
    @comments = Comment.includes(post: :user).order(created_at: :desc).limit(100)
  end
end
