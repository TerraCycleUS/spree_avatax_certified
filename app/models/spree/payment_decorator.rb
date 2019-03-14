Spree::Payment.class_eval do
  state_machine.after_transition to: :completed, do: :avalara_finalize

  def avalara_tax_enabled?
    Spree::Config.avatax_tax_calculation
  end

  def avalara_finalize
    return unless avalara_tax_enabled?
    return if order.outstanding_balance?

    order.avalara_capture_finalize
  end
end
