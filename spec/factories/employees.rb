FactoryGirl.define do

  factory :employee do
    sequence :name do |n|
      "#{Faker::Commerce.department}#{n}"
    end
    email { Faker::Internet.email }
    phone_number { "9123456789" }
    birthday { Faker::Date.backward(3) }
    gender { "male" }
  end

end
