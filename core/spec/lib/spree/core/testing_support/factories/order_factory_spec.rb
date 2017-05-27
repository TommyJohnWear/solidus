require 'spec_helper'
require 'spree/testing_support/factories/order_factory'

shared_examples "shipping methods are assigned" do
  context "given a shipping method" do
    let(:shipping_method) { create(:shipping_method) }

    it "assigns the shipping method when created" do
      expect(
        create(
          factory,
          shipping_method: shipping_method
        ).shipments.all? do |shipment|
          shipment.shipping_method == shipping_method
        end
      ).to be true
    end

    it "assigns the shipping method when built" do
      expect(
        build(
          factory,
          shipping_method: shipping_method
        ).shipments.all? do |shipment|
          shipment.shipping_method == shipping_method
        end
      ).to be true
    end
  end
end

RSpec.describe 'order factory' do
  let(:factory_class) { Spree::Order }

  describe 'plain order' do
    let(:factory) { :order }

    it_behaves_like 'a working factory'
  end

  describe 'order with totals' do
    let(:factory) { :order_with_totals }

    it_behaves_like 'a working factory'
  end

  describe 'order with line items' do
    let(:factory) { :order_with_line_items }

    it_behaves_like 'a working factory'
    it_behaves_like 'shipping methods are assigned'
  end

  describe 'completed order with totals' do
    let(:factory) { :completed_order_with_totals }

    it_behaves_like 'a working factory'
    it_behaves_like 'shipping methods are assigned'
  end

  describe 'completed order with pending payment' do
    let(:factory) { :completed_order_with_pending_payment }

    it_behaves_like 'a working factory'
    it_behaves_like 'shipping methods are assigned'
  end

  describe 'order ready to ship' do
    let(:factory) { :order_ready_to_ship }

    it_behaves_like 'a working factory'
    it_behaves_like 'shipping methods are assigned'
  end

  describe 'shipped order' do
    let(:factory) { :shipped_order }

    it_behaves_like 'a working factory'
    it_behaves_like 'shipping methods are assigned'
  end
end
