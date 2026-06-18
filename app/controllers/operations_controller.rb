class OperationsController < ApplicationController

  WithdrawSchema = Dry::Schema.Params do
    required(:operation).hash do
      required(:from).filled(:string)
      required(:amount).filled(:integer, gt?: 0)
    end
  end

  DepositSchema = Dry::Schema.Params do
    required(:operation).hash do
      required(:to).filled(:string)
      required(:amount).filled(:integer, gt?: 0)
    end
  end

  TransferSchema = Dry::Schema.Params do
    required(:operation).hash do
      required(:to).filled(:string)
      required(:from).filled(:string)
      required(:amount).filled(:integer, gt?: 0)
    end
  end

  def withdraw
    result = WithdrawSchema.call(params.permit!.to_h)

    if result.success?
      operation_info = result.to_h[:operation]

      account = Account.find_by(number: operation_info[:from])
      return render status: :not_found, json: {errors: {account: "not found"}}unless account.present?

      ActiveRecord::Base.transaction do
        operation = Operation.create!
        Transaction.create!(account_id: account.id, operation_id: operation.id, amount: -operation_info[:amount])
        account.update!(balance: account.balance - operation_info[:amount])
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: result.errors.to_h}, status: :unprocessable_entity
    end
  end

  def deposit
    result = DepositSchema.call(params.permit!.to_h)

    if result.success?
      operation_info = result.to_h[:operation]

      account = Account.find_by(number: operation_info[:to])
      return render status: :not_found, json: {errors: {account: "not found"}} unless account.present?

      ActiveRecord::Base.transaction do
        operation = Operation.create!
        Transaction.create!(account_id: account.id, operation_id: operation.id, amount: operation_info[:amount])
        account.update!(balance: account.balance + operation_info[:amount])
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: result.errors.to_h }, status: :unprocessable_entity
    end
  end

  def transfer
    result = TransferSchema.call(params.permit!.to_h)

    if result.success?
      operation_info = result.to_h[:operation]

      from_account = Account.find_by(number: operation_info[:from])
      return render status: :not_found, json: {errors: {account: "not found"}} unless from_account.present?
      to_account = Account.find_by(number: operation_info[:to])
      return render status: :not_found, json: {errors: {account: "not found"}} unless to_account.present?


      ActiveRecord::Base.transaction do
        operation = Operation.create!
        Transaction.create!(account_id: from_account.id, operation_id: operation.id, amount: -operation_info[:amount])
        from_account.update!(balance: from_account.balance - operation_info[:amount])
        Transaction.create!(account_id: to_account.id, operation_id: operation.id, amount: operation_info[:amount])
        to_account.update!(balance: to_account.balance + operation_info[:amount])
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: result.errors.to_h }, status: :unprocessable_entity
    end
  end
end
