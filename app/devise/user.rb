# frozen_string_literal: true

class User < ApplicationRecord
  devise :http_header_authenticatable
end
