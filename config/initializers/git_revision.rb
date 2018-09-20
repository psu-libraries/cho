# frozen_string_literal: true

class Git
  class << self
    def revision
      @revision ||= git_revision
    end

    private

      def git_revision
        return unless Rails.root.join('REVISION').exist?
        Rails.root.join('REVISION').read.chomp
      end
  end
end
