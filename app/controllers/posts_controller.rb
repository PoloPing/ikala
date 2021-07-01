class PostsController < ApplicationController
    before_action :authenticate_user!, :except=> [:index]


    def index
        @user = current_user
        @posts = Post.order("updated_at DESC").page(params[:page]).per(Rails.application.config.paganation_number)
    end

    def new
        @notice = params[:notice]
    end

    def edit
        @notice = params[:notice]
        @post = Post.where("id = ?",  params[:id]).first
        unless @post.present?
            redirect_to :action => :index
            return 
        end
        
    end

    def create
        if params[:post].blank?
            redirect_to :action => :new, :notice=>'資料格式不對'
            return 
        end

        if params[:post][:title].blank?
            redirect_to :action => :new, :notice=>'請輸入文章標題'
            return 
        end

        if params[:post][:content].blank?
            redirect_to :action => :new, :notice=>'請輸入文章內容'
            return 
        end

        @post = Post.new(post_list_params)
        @post.user_id = current_user.id
        @post.save
        redirect_to :action => :index
    end

    def update
        if params[:post].blank?
            redirect_to :action => :new, :notice=>'資料格式不對'
            return 
        end

        if params[:post][:title].blank?
            redirect_to :action => :edit, :notice=>'請輸入文章標題'
            return 
        end
        if params[:post][:content].blank?
            redirect_to :action => :edit, :notice=>'請輸入文章內容'
            return 
        end

        post = Post.find(params[:id])
        unless post.user_id == current_user.id
            redirect_to :action => :edit, :notice=>'使用者沒有權限修改此文章'
            return 
        end
        post.update(post_list_params)
        redirect_to :action => :index

    end

    def destroy
        post = Post.where("id = ?",  params[:id]).first

        unless post.present?
            redirect_to :action => :index
            return 
        end

        unless post.user_id == current_user.id
            redirect_to :action => :index
            return 
        end

        post.destroy
        redirect_to :action => :index
    end

    private
    def post_list_params
      params.require(:post).permit(:title, :content)
    end

end
