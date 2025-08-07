class ImportUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    external_user = JsonPlaceholderClient.find_user_by_username(user.username)
    return unless external_user

    user.update!(external_id: external_user["id"])

    posts = JsonPlaceholderClient.fetch_posts(external_user["id"])
    posts.each do |post_data|
      post = Post.find_or_create_by!(
        external_id: post_data["id"],
        user: user
      )
      ImportCommentsJob.perform_later(post.id)
    end
  end
end
