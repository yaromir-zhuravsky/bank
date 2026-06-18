module Operations
  class Deposit
    def self.perform(account, amount)
      ActiveRecord::Base.transaction do
        operation = Operation.create!
        Transaction.create!(account_id: account.id, operation_id: operation.id, amount:)
        account.add!(amount)
      end
    end
  end
end
