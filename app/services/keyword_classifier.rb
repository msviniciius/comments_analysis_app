class KeywordClassifier
  def self.match_count(text)
    keywords = Keyword.pluck(:name).map(&:downcase)
    return 0 if text.blank?

    words = text.downcase.scan(/\w+/)
    words.count { |w| keywords.include?(w) }
  end
end
