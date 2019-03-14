require 'spec_helper'

describe Spree::Payment, :vcr do
  subject(:order) do
    order = FactoryBot.create(:completed_order_with_totals)
    Spree::AvalaraTransaction.create(order: order)
    order
  end

  let(:gateway) do
    gateway = Spree::Gateway::Bogus.create(active: true, name: 'Bogus')
    allow(gateway).to receive_messages :environment => 'test'
    allow(gateway).to receive_messages source_required: true
    gateway
  end

  let(:card) { create :credit_card }

  let(:amount) { 5 }
  let(:payment) do
    payment = Spree::Payment.new
    payment.source = card
    payment.order = order
    payment.payment_method = gateway
    payment.amount = amount
    payment
  end


  let(:amount_in_cents) { (payment.amount * 100).round }

  let!(:success_response) do
    double('success_response', :success? => true,
           :authorization => '123',
           :avs_result => { 'code' => 'avs-code' },
           :cvv_result => { 'code' => 'cvv-code', 'message' => "CVV Result"})
  end

  let(:failed_response) { double('gateway_response', :success? => false) }

  before(:each) do
    allow(payment.log_entries).to receive(:create!)
  end

  describe "#purchase!" do
    subject do
      VCR.use_cassette('order_capture_finalize', allow_playback_repeats: true) do
        payment.purchase!
      end
    end

    context 'payment covers the total' do
      let(:amount) { order.total }

      it 'receive avalara_finalize' do
        expect(order).to receive(:avalara_capture_finalize).once
        subject
      end
    end

    context 'partial payment' do
      let(:amount) { 1 }

      it 'do not receive avalara_finalize' do
        expect(order).to_not receive(:avalara_capture_finalize)
        subject
      end
    end

    context 'multiple payment' do
      let(:amount) { order.total - 1 }
      let(:payment2) do
        payment = Spree::Payment.new
        payment.source = card
        payment.order = order
        payment.payment_method = gateway
        payment.amount = 1
        payment
      end

      before { payment2.purchase! }

      it 'receive avalara_finalize once' do
        expect(order).to receive(:avalara_capture_finalize).once
        subject
      end
    end
  end
end
