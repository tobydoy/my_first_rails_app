class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :recommendation, foreign_key: true, null: false

      t.timestamps
    end

    add_index :likes, [:user_id, :recommendation_id], unique: true
  end
end
