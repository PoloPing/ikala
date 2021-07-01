class Post < ApplicationRecord
    before_destroy :destroy_comments
    has_many :post_comments, :dependent => :destroy
    has_many :comments, :through => :post_comments, source: :comment
    belongs_to :user

    def destroy_comments
        Comment.where(:id => self.post_comments.ids).destroy_all
    end
end
