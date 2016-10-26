class AddAmountRemainingToStoreCreditEvents < ActiveRecord::Migration
  def up
    add_column :spree_store_credit_events, :amount_remaining, :decimal, precision: 8, scale: 2, default: nil, null: true

    Spree::StoreCredit.all.each do |credit|
      credit_amount = credit.amount

      credit.store_credit_events.chronological.each do |event|
        case event.action
        when Spree::StoreCredit::ALLOCATION_ACTION,
             Spree::StoreCredit::ELIGIBLE_ACTION,
             Spree::StoreCredit::CAPTURE_ACTION
          # These actions do not change the amount_remaining so the previous
          # amount available is used (either the credit's amount or the
          # amount_remaining coming from the event right before this one).
        when Spree::StoreCredit::AUTHORIZE_ACTION,
             Spree::StoreCredit::INVALIDATE_ACTION
          # These actions remove the amount from the available credit amount.
          credit_amount -= event.amount
        when Spree::StoreCredit::ADJUSTMENT_ACTION,
             Spree::StoreCredit::CREDIT_ACTION,
             Spree::StoreCredit::VOID_ACTION
          # These actions add the amount to the available credit amount. For
          # ADJUSTMENT_ACTION the event's amount could be negative (so it could
          # end up subtracting the amount).
          credit_amount += event.amount
        end

        event.update_attribute(:amount_remaining, credit_amount)
      end
    end
  end

  def down
    remove_column :spree_store_credit_events, :amount_remaining
  end
end
