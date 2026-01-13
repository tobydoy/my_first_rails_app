class Recommendation < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { maximum: 200 }
  validates :recommendation_type, presence: true, inclusion: { in: %w[evergreen time_location] }
  validates :category, presence: true

  # Scopes
  scope :evergreen, -> { where(recommendation_type: 'evergreen') }
  scope :time_location, -> { where(recommendation_type: 'time_location') }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(likes_count: :desc) }
  scope :by_category, ->(category) { where(category: category) }
  scope :with_location, -> { where.not(latitude: nil, longitude: nil) }
  scope :events, -> { where(is_event: true) }

  # Near scope for location-based queries (basic implementation)
  scope :near_location, ->(lat, lng, distance_in_km = 50) {
    where(
      "latitude BETWEEN ? AND ? AND longitude BETWEEN ? AND ?",
      lat - (distance_in_km / 111.0),
      lat + (distance_in_km / 111.0),
      lng - (distance_in_km / 111.0),
      lng + (distance_in_km / 111.0)
    )
  }

  # Methods
  def liked_by?(user)
    likes.exists?(user: user)
  end

  def toggle_like(user)
    if liked_by?(user)
      likes.find_by(user: user).destroy
      decrement!(:likes_count)
    else
      likes.create(user: user)
      increment!(:likes_count)
    end
  end
end
