class Comment < ApplicationRecord
    has_many :post_comments
    has_one :post, through: :post_comments, source: :post
    belongs_to :user
end
