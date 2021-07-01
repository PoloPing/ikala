class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.integer :user_id, index: true
      t.timestamps
    end
  end
end
