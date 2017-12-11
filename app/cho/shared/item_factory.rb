# frozen_string_literal: true

class ItemFactory
  class << self
    def items=(new_items)
      non_items = new_items.reject { |_label, item| item.is_a? item_class }
      if non_items.present?
        send_error(non_items.keys.join(', '))
      end

      @items = new_items.merge(default_items)
    end

    def items
      @items ||= default_items
    end

    def lookup(name)
      items[name]
    end

    def names
      items.keys.map(&:to_s)
    end

    def default_key
      raise NotImplementedError.new('ItemFactory.none_key is abstract and must be implemented')
    end

    private

      def default_items
        raise NotImplementedError.new('ItemFactory.default_items is abstract and must be implemented')
      end

      def item_class
        raise NotImplementedError.new('ItemFactory.item_class is abstract and must be implemented')
      end

      def send_error(_error_list)
        raise NotImplementedError.new('ItemFactory.send_error is abstract and must be implemented')
      end
  end
end
