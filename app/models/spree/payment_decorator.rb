# frozen_string_literal: true

module Spree
  module PaymentDecorator
    def self.prepended(base)
      base.state_machine.after_transition to: :completed, do: :avalara_finalize
    end

    def avalara_tax_enabled?
      Spree::Config.avatax_tax_calculation
    end

    def avalara_finalize
      return unless avalara_tax_enabled?
      return if order.outstanding_balance?

      order.avalara_capture_finalize
    end
  end
end

Spree::Payment.prepend Spree::PaymentDecorator
