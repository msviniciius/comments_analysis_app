class KeywordsController < ApplicationController
  before_action :set_keyword, only: [:edit, :update, :destroy]

  def index
    @keywords = Keyword.order(:name)

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @keywords }
    end
  end

  def create
    @keyword = Keyword.new(keyword_params)
    if @keyword.save
      enqueue_reprocessing
      redirect_to keywords_path, notice: 'Palavra-chave criada com sucesso.'
    else
      @keywords = Keyword.order(:word)
      render :index
    end
  end

  def edit
  end

  def update
    if @keyword.update(keyword_params)
      redirect_to keywords_path, notice: 'Palavra-chave atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @keyword.destroy
    redirect_to keywords_path, notice: 'Palavra-chave removida com sucesso.'
  end

  private

  def set_keyword
    @keyword = Keyword.find(params[:id])
  end

  def enqueue_reprocessing
    User.find_each do |user|
      RecalculateMetricsJob.perform_later(user.id)
    end
  end

  def keyword_params
    params.require(:keyword).permit(:name)
  end
end
