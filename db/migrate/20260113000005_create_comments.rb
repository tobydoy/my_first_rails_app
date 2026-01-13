class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :recommendation, foreign_key: true, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :comments, :created_at
  end
end
