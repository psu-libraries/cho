# frozen_string_literal: true

FactoryGirl.define do
  sequence :login do |n|
    "user#{n}"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    login
    email

    factory :admin do
      group_list 'umg/up.libraries.cho-admin'
      groups_last_update { Time.now }
    end
  end
end
