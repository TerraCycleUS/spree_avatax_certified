require 'spec_helper'

describe Spree::Admin::AvalaraEntityUseCodesController do
  let(:avalara_entity_use_code) { FactoryBot.create(:avalara_entity_use_code) }

  stub_authorization!

  before :each do
    DatabaseCleaner.clean
  end

  describe "#index" do
    subject { get :index }

    it { is_expected.to be_successful }
  end

  describe "#show" do
    subject { get :show, params: { id: avalara_entity_use_code.id } }

    it { is_expected.to be_successful }
  end

  describe "#new" do
    subject {get :new }

    it { is_expected.to be_successful }
  end

  describe "#edit" do
    subject {get :edit, params: { id: avalara_entity_use_code.id } }

    it { is_expected.to be_successful }
  end

  describe "#update" do
    let(:params) do
      {
        id: avalara_entity_use_code.to_param,
        avalara_entity_use_code: {
          use_code: "55",
        }
      }
    end
    subject { put :update, params: params }

    it { is_expected.to redirect_to(spree.admin_avalara_entity_use_codes_path) }
    it "expect @use_code to eq the use_code being updated" do
      expect(assigns(:avalara_entity_use_code)).to eq(@use_code)
    end

    it "should update use_code" do
      expect{subject}.to change { avalara_entity_use_code.reload.use_code }.from('A').to('55')
    end
  end
end
