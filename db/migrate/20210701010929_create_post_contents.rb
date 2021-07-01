class CreatePostContents < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.integer :post_id, index: true
      t.integer :comment_id, index: true

      t.timestamps
    end
  end
end
