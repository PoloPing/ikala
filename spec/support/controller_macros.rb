


FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { "password"} 
      password_confirmation { "password" }
    end
end

FactoryBot.define do
    factory :track_list do
      name { Faker::Name.name }
      user
    end
end

FactoryBot.define do
    factory :stock do
      number { Faker::Number.number }
      name { Faker::Name.name }
    end
end


FactoryBot.define do
    factory :track_list_content do
        track_list
        stock
    end
end


module ControllerMacros
  
    def login_user
      before(:each) do
        user = User.find(1)
        sign_in user
      end
    end

    def login_random_user
      before(:each) do
        user = FactoryBot.create(:user)
        sign_in user
      end
    end
  end