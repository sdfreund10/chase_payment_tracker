# frozen_string_literal: true

require 'csv'

class TransactionsImporter
  attr_reader :account

  def initialize(file_name, user, account: nil, type: nil)
    @file = File.open(file_name)
    @user = user
    @account = account
    if ["Credit", "Debit", "Savings", nil].include? type
      @type = type
    else
      raise "Must provide valid account type"
    end
  end

  def account
    @account ||= find_account
  end

  def transaction_type
    "#{@type}Transaction" unless @type.nil?
  end

  def account_type
    "#{@type}Account" unless @type.nil?
  end

  def import_file_data
    raise "Cannot determine account" if account.nil?
  end

  private

  def file_data
    CSV.foreach(@file_name, headers: true) do |row|
      yield row
    end
  end

  def find_account
    unless account_number.blank?
      Account.find_or_create_by(
        user: @user, account_number: account_number
      )
    end
  end

  def account_number
    @file.path[/(?<=chase)\d{4}/i]
  end

  def file_type
    headers = CSV.open(@file_name, &:readline)
    if headers.sort == ["Type", "Trans Date", "Post Date", "Description", "Amount"]
      :credit
    else
      debit_or_savings
    end
  end

  def debit_or_savings
    CSV.read(@file_name, headers: true)["Type"]
  end
end
