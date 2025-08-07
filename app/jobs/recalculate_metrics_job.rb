class RecalculateMetricsJob < ApplicationJob
  queue_as :critical

  def perform(user_id = nil)
    if user_id
      recalculate_for_user(User.find(user_id))
    end

    recalculate_group_metrics
  end

  private

  def recalculate_for_user(user)
    approved_lengths = user.comments.where(status: "approved").pluck(:translated_content).compact.map(&:length)

    metrics = calculate_stats(approved_lengths)

    metric = Metric.find_or_initialize_by(user: user, is_group: false)
    metric.update!(metrics)
  end

  def recalculate_group_metrics
    approved_lengths = Comment.where(status: "approved").pluck(:translated_content).compact.map(&:length)

    metrics = calculate_stats(approved_lengths)

    metric = Metric.find_or_initialize_by(user: nil, is_group: true)
    metric.update!(metrics)
  end

  def calculate_stats(lengths)
    return { avg: 0, median: 0, std_dev: 0, count: 0 } if lengths.empty?

    {
      avg: lengths.mean,
      median: lengths.median,
      std_dev: lengths.standard_deviation,
      count: lengths.size
    }
  end
end