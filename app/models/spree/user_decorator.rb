# frozen_string_literal: true

module Spree
  module UserDecorator
    def self.prepended(base)
      base.belongs_to :avalara_entity_use_code
    end
  end
end

Spree.user_class.prepend Spree::UserDecorator
