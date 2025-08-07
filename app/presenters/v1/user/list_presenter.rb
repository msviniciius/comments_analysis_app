module V1
  module User
    class ListPresenter
      def initialize(users)
        @users = users
      end

      def as_json(*)
        {
          users: @users.map do |user|
            {
              id: user.id,
              username: user.username,
              metrics: format_metric(user.metric)
            }
          end,
          group_metrics: format_metric(Metric.find_by(is_group: true))
        }
      end

      private

      def format_metric(metric)
        return nil unless metric
        {
          avg: metric.avg,
          median: metric.median,
          std_dev: metric.std_dev,
          count: metric.count
        }
      end
    end
  end
end
