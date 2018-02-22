# frozen_string_literal: true

class User < ApplicationRecord
  include Blacklight::User
  devise :http_header_authenticatable
end
