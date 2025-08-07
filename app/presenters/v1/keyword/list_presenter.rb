module V1
  module Keyword
    class ListPresenter
      def initialize(keywords)
        @keywords = keywords
      end

      def as_json(*)
        @keywords.map do |keyword|
          {
            id: keyword.id,
            word: keyword.name
          }
        end
      end
    end
  end
end
