# frozen_string_literal: true

class User < ApplicationRecord
  include Blacklight::User
  include Blacklight::AccessControls::User
  devise :http_header_authenticatable

  # @return [Array<String>]
  def groups
    ldap_groups + default_groups
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

  private

    def ldap_groups
      populate_attributes if groups_last_update.blank? || ((Time.now - groups_last_update) > 1.day)

      group_list.split(';?;')
    end

    def default_groups
      return [] if login.blank?

      [Repository::AccessControls::AccessLevel.psu]
    end
end
