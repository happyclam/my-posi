FactoryGirl.define do
#  id          :integer          not null, primary key
#  name        :string(255)
#  provider    :string(255)
#  screen_name :string(255)
#  uid         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
  factory :user do
    sequence(:name)  { |n| "Name #{n}" }
    provider "twitter"
    sequence(:screen_name)  { |n| "ScreenName #{n}" }
    uid 10000
  end

  factory :strategy do
    sequence(:name)  { |n| "Strategy #{n}" }
    draw_type 1
    range 500
    interest 0.05
    sigma 0.2
    user
  end

  # factory :user do
  #   sequence(:name)  { |n| "Person #{n}" }
  #   sequence(:email) { |n| "person_#{n}@example.com"}
  #   password "foobar"
  #   password_confirmation "foobar"
  #   factory :admin do
  #     admin true
  #   end
  # end
  # factory :track do
  #   tag "Lorem ipsum"
  #   user
  # end
  # factory :serv do
  #   track "#NHK"
  #   status 0
  #   user
  # end

end
