require 'rails_helper'

RSpec.describe "Posts", type: :request do
  fixtures :users, :posts, :comments, :post_comments

  let(:valid_params) do
    {
      post:
        {
          title: "test5",
          content: "test5",
        }
    }
  end

  let(:not_valid_params_empty) do
    {
      post:
        {
          title: "",
          content: "",
        }
    }
  end

  let(:not_valid_params_wrong_format) do
    {
        title: "test1",
        content: "test2",
    }
  end
  
  describe "Login as a default user" do
    login_user
    
    it 'create a post' do 
      post "/posts/", params: valid_params
      expect(response).to have_http_status(302)
      assert Post.count == 12
    end

    it 'create a post with empty value' do 
      post "/posts/", params: not_valid_params_empty
      expect(response).to have_http_status(302)
      assert Post.count == 11
    end

    it 'create a post with wrong format' do 
      post "/posts/", params: not_valid_params_wrong_format
      expect(response).to have_http_status(302)
      assert Post.count == 11
    end

    it 'update a post' do 
      put "/posts/1", params: valid_params
      expect(response).to have_http_status(302)
      post = Post.find(1)
      
      assert post.title == valid_params[:post][:title]
      assert post.content == valid_params[:post][:content]
    end

    it 'update a post with empty value' do 
      post = Post.find(1)
      old_title = post.title
      old_content = post.content
      put "/posts/1", params: not_valid_params_empty
      expect(response).to have_http_status(302)

      assert post.title == old_title
      assert post.content == old_content
    end

    it 'update a post with wrong format' do 
      post = Post.find(1)
      old_title = post.title
      old_content = post.content
      put "/posts/1", params: not_valid_params_wrong_format
      expect(response).to have_http_status(302)

      assert post.title == old_title
      assert post.content == old_content
    end

    it 'delete a post' do 
      delete "/posts/1"
      expect(response).to have_http_status(302)
      assert !Post.where("id = 1").exists?
    end

    it 'delete a post not exists' do 
      delete "/posts/15"
      expect(response).to have_http_status(302)
      assert Post.count == 11
    end
  end

  describe "Login as a random user" do

    login_random_user

    it 'delete a post which not belongs to user' do 
      delete "/posts/1"
      expect(response).to have_http_status(302)
      assert Post.where("id = 1").exists?
    end

    it 'update a post which not belongs to user' do 
      post = Post.find(1)
      old_title = post.title
      old_content = post.content
      put "/posts/1", params: valid_params
      expect(response).to have_http_status(302)
      post = Post.find(1)
      assert post.title == old_title
      assert post.content == old_content
    end
  end 
end
