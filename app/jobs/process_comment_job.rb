require 'descriptive_statistics'

class ProcessCommentJob < ApplicationJob
  queue_as :critical

  def perform(comment_id)
    comment = Comment.find(comment_id)

    translated = GoogleTranslateService.translate(comment.content, from: 'auto', to: 'pt')
    comment.translated_content = translated

    match_count = KeywordClassifier.match_count(translated)

    if match_count >= 2
      comment.status = "approved"
    else
      comment.status = "rejected"
    end

    comment.save!

    # Após atualizar o comentário, recalcula métricas do usuário
    RecalculateMetricsJob.perform_later(comment.post.user_id)
  end
end
