# frozen_string_literal: true

class OperationsController < ApplicationController
  include Authenticatable

  def withdraw
    validate_params!(OperationsSchema::Withdraw) => { operation: { from:, amount: } }
    account = Account.find_by!(number: from)
    OperationsService.withdraw(account, amount)

    head :ok
  end

  def deposit
    validate_params!(OperationsSchema::Deposit) => { operation: { to:, amount: } }
    account = Account.find_by!(number: to)
    OperationsService.deposit(account, amount)

    head :ok
  end

  def transfer
    validate_params!(OperationsSchema::Transfer) => { operation: { from:, to:, amount: } }
    sender_account = Account.find_by!(number: from)
    receiver_account = Account.find_by!(number: to)
    OperationsService.transfer(sender_account, receiver_account, amount)

    head :ok
  end
end
