class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(product_question)
    AnswerNotificationMailer.answer_notification(product_question).deliver_later
  end
end

# touched on 2025-05-22T21:18:54.750699Z
