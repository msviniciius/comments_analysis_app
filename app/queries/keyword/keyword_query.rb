module Query
  module Keyword
    class KeywordQuery
      attr_accessor :order

      def fetch
        scope = ::Keyword.all
        scope = scope.order(order) if order.present?
        scope
      end
    end
  end
end