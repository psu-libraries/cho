# frozen_string_literal: true

class User < ApplicationRecord
  include Blacklight::User
  devise :http_header_authenticatable

  def groups
    return group_list.split(';?;') unless groups_last_update.blank? || ((Time.now - groups_last_update) > 24 * 60 * 60)

    populate_attributes
    group_list.split(';?;')
  end

  def admin?
    groups.include?('umg/up.libraries.cho-admin')
  end

  def populate_attributes
    list = PsuDir::LdapUser.get_groups(login).sort!
    return if list.empty?

    Rails.logger.debug "$#{login}$ groups = #{list}"
    update(group_list: list.join(';?;'), groups_last_update: Time.now)
  end
end
