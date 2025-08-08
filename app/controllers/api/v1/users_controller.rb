module Api
  module V1
    class UsersController < Api::BaseController
      def create
        username = params[:username]
        user = User.find_or_create_by!(username: username)
        ImportUserJob.perform_later(user.id)

        render json: { message: 'Importação iniciada', user_id: user.id }, status: :accepted
      end

      def index
        @query = UserQuery.new
        @query.order = params[:order]
        @presenter = ::V1::User::ListPresenter.new(@query.fetch)

        render json: @presenter
      end
    end
  end
end
