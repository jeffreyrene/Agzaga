module Spree
  class HelpCenter < Spree::Base
    acts_as_list
    enum question_type: { FAQs: 0, Shippings: 1 }
    validates :question, presence: true
    validates :answer, presence: true
    validates :question_type, presence: true
  end
end

# touched on 2025-05-22T22:36:06.737277Z
