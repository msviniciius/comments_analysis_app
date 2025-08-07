class JsonPlaceholderClient
  include HTTParty
  base_uri 'https://jsonplaceholder.typicode.com'

  def self.find_user_by_username(username)
    users = get('/users')
    users.find { |u| u["username"].downcase == username.downcase }
  end

  def self.fetch_posts(user_id)
    get("/posts", query: { userId: user_id })
  end

  def self.fetch_comments(post_id)
    get("/comments", query: { postId: post_id })
  end
end
