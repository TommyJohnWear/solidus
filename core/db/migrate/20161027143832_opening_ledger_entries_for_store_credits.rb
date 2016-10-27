class OpeningLedgerEntriesForStoreCredits < ActiveRecord::Migration
  def up
    Rake::Task["solidus:migrations:create_ledger_entries_for_store_credits:up"].invoke
  end

  def down
    Rake::Task["solidus:migrations:create_ledger_entries_for_store_credits:down"].invoke
  end
end
