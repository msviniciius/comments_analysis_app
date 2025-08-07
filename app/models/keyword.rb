class Keyword < ApplicationRecord
  after_commit :trigger_reprocessing, on: [:create, :destroy]
  after_update_commit :trigger_reprocessing_if_changed

  private

  def trigger_reprocessing
    ReprocessAllCommentsJob.perform_later
  end

  def trigger_reprocessing_if_changed
    trigger_reprocessing if saved_change_to_name?
  end
end
