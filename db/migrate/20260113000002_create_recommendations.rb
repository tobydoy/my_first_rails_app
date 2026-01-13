class CreateRecommendations < ActiveRecord::Migration[5.2]
  def change
    create_table :recommendations do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description
      t.string :recommendation_type, default: 'evergreen' # 'evergreen' or 'time_location'
      t.string :category
      t.string :product_url
      t.string :affiliate_link
      t.string :image_url

      # Location fields
      t.string :location_name
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      # Time fields for events
      t.datetime :event_date
      t.boolean :is_event, default: false

      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end

    add_index :recommendations, :user_id
    add_index :recommendations, :recommendation_type
    add_index :recommendations, :category
    add_index :recommendations, :created_at
    add_index :recommendations, [:latitude, :longitude]
  end
end
