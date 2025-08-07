class UserQuery
  attr_accessor :order

  def fetch
    scope = User.includes(:posts, :metrics)
    scope = scope.order(order) if order.present?
    scope
  end
end
