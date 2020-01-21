# frozen_string_literal: true

module Spree
  module AdjustmentDecorator
    def self.prepended(base)
      base.scope :not_tax, -> { where.not(source_type: 'Spree::TaxRate') }
    end

    def avatax_cache_key
      key = ['Spree::Adjustment']
      key << id
      key << amount
      key.join('-')
    end
  end
end

Spree::Adjustment.prepend Spree::AdjustmentDecorator
