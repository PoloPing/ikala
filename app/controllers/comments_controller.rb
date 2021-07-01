class CommentsController < ApplicationController
    def new
        @post_id = params[:post_id]
        @notice = params[:notice]
        unless @post_id
            redirect_to :controller => 'posts', :action => 'index'
        end
        
    end

    def create
        if params[:post_id].blank?
            redirect_to :controller => 'posts', :action => 'index'
            return 
        end

        if params[:content].blank?
            redirect_to :action => :new, :notice=>'請輸入評論內容', :post_id=>params[:post_id]
            return 
        end
        PostComment.transaction do
            comment = Comment.new()
            comment.content = params[:content]
            comment.user_id = current_user.id
            comment.save
            post_comment = PostComment.new()
            post_comment.post_id = params[:post_id]
            post_comment.comment_id = comment.id
            post_comment.save
        end
        redirect_to :controller => 'posts', :action => 'index'
    end
end
