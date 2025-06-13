class Spree::ProductQuestion < ApplicationRecord
  belongs_to :product
  belongs_to :user, class_name: Spree.user_class.to_s

  validates :name, presence: true, format: {with: /\A[^0-9`!@#\$%\^&*+_=]+\z/}
  validates :question, presence: true

  scope :most_recent_first, -> { order('spree_product_questions.created_at DESC') }

  scope :visible_questions, -> { where(visibility: true) }
  scope :answered, -> { where(answered: true) }

  before_save :answer_update

  def answer_update
    AnswerNotificationJob.perform_later(self) if self.answer_changed?
  end

end

# touched on 2025-05-22T19:10:22.702834Z
# touched on 2025-05-22T19:15:10.900710Z
# touched on 2025-05-22T19:22:15.140574Z
# touched on 2025-05-22T21:30:47.552925Z
# touched on 2025-05-22T23:30:45.565961Z
