require 'rails_helper'

RSpec.describe "Comments", type: :request do
  fixtures :users, :posts, :comments, :post_comments

  let(:valid_params) do
    {
      post_id: 1,
      content: "test1",
    }
  end

  let(:not_valid_params_empty) do
    {}
  end

  let(:not_valid_params_with_wrong_post_id) do
    {
      post_id: 15
    }
  end

  let(:not_valid_params_wrong_format) do
    {
      comment:
        {
          post_id: 1,
          content: "test1",
        }
    }
  end
  describe "Login as a default user" do
    login_user
    it 'create a comment' do 
      post "/comments/", params: valid_params
      expect(response).to have_http_status(302)
      assert Comment.count == 14
    end

    it 'create a comment with empty value' do 
      post "/posts/", params: not_valid_params_empty
      expect(response).to have_http_status(302)
      assert Comment.count == 13
    end

    it 'create a post with an wrong post_id' do 
      post "/posts/", params: not_valid_params_with_wrong_post_id
      expect(response).to have_http_status(302)
      assert Comment.count == 13
    end
  
    it 'create a post with wrong format' do 
      post "/posts/", params: not_valid_params_wrong_format
      expect(response).to have_http_status(302)
      assert Comment.count == 13
    end
  end
end
