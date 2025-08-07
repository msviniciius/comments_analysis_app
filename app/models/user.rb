class User < ApplicationRecord
  has_many :posts
  has_many :comments, through: :posts
  has_one :metric, -> { where(is_group: false) }

  after_create_commit -> { RecalculateMetricsJob.perform_later(id) }
end
