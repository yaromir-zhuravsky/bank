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
    return render json: { errors: result.errors.to_h }, status: :unprocessable_entity unless result.success?

    operation_info = result.to_h[:operation]
    amount = operation_info[:amount]

    account = Account.find_by(number: operation_info[:from])
    return render status: :not_found, json: {errors: {account: "not found"}}unless account.present?

    Operations::Withdraw.perform(account, amount)

    head :ok

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def deposit
    result = DepositSchema.call(params.permit!.to_h)
    return render json: { errors: result.errors.to_h }, status: :unprocessable_entity unless result.success?

    operation_info = result.to_h[:operation]
    amount = operation_info[:amount]

    account = Account.find_by(number: operation_info[:to])
    return render status: :not_found, json: {errors: {account: "not found"}} unless account.present?

    Operations::Deposit.perform(account, amount)

    head :ok

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  def transfer
    result = TransferSchema.call(params.permit!.to_h)
    return render json: { errors: result.errors.to_h }, status: :unprocessable_entity unless result.success?

    operation_info = result.to_h[:operation]
    amount = operation_info[:amount]

    sender_account = Account.find_by(number: operation_info[:from])
    return render status: :not_found, json: {errors: {account: "not found"}} unless sender_account.present?
    receiver_account = Account.find_by(number: operation_info[:to])
    return render status: :not_found, json: {errors: {account: "not found"}} unless receiver_account.present?

    Operations::Transfer.perform(sender_account, receiver_account, amount)

    head :ok

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end
end
