# frozen_string_literal: true

FactoryBot.define do
  sequence :login do |n|
    "user#{n}"
  end

  factory :user do
    # DeviseRemote creates users with the same login and email using ENV['REMOTE_USER']
    login
    email { login }

    to_create do |user|
      user.save!
      user
    end

    factory :admin do
      group_list { 'umg/up.libraries.cho-admin' }
      groups_last_update { Time.now }
    end

    factory :psu_user do
      # This is a fake group to contrast with an actual admin group
      group_list { 'umg/up.libraries.staff' }
      groups_last_update { Time.now }
    end

    trait :in_private_group do
      group_list { 'private_group' }
      groups_last_update { Time.now }
    end
  end
end
