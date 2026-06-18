class OperationsController < ApplicationController
  def withdraw
    ActiveRecord::Base.transaction do
      account = Account.find_by(number: params[:number])
      operation = Operation.create!
      Transaction.create(account_id: account.id, operation_id: operation.id, amount: -(params[:amount]))
      account.update(balance: account.balance - params[:amount])
      account.save!
    end
  end

  def deposit
    ActiveRecord::Base.transaction do
      account = Account.find_by(number: params[:number])
      operation = Operation.create!
      Transaction.create(account_id: account.id, operation_id: operation.id, amount: (params[:amount]))
      account.update(balance: account.balance + params[:amount])
      account.save!
    end
  end

  def transfer
    ActiveRecord::Base.transaction do
      from_account = Account.find_by(number: params[:from_number])
      to_account = Account.find_by(number: params[:to_number])
      operation = Operation.create!
      Transaction.create(account_id: from_account.id, operation_id: operation.id, amount: -(params[:amount]))
      from_account.update(balance: from_account.balance - params[:amount])
      from_account.save!
      Transaction.create(account_id: to_account.id, operation_id: operation.id, amount: (params[:amount]))
      to_account.update(balance: to_account.balance + params[:amount])
      to_account.save!
    end
  end
end
