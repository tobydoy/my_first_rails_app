class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recommendation, counter_cache: true

  validates :content, presence: true, length: { maximum: 1000 }

  scope :recent, -> { order(created_at: :desc) }
end
