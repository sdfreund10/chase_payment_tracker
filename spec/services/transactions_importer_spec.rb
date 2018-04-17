require 'rails_helper'

RSpec.describe TransactionsImporter do
  before(:all) do
    @user = User.create(
      name: "Test User", email: "sample@test.com",
      password: "foobar", password_confirmation: "foobar"
    )
  end

  let(:credit_file) { file_fixture("Chase9999_sample_credit_activity.csv") }
  let(:debit_file) { file_fixture("Chase9999_sample_debit_activity.csv") }
  let(:savings_file) { file_fixture("Chase9999_sample_savings_activity.csv") }

  it "determines account from file" do
    account = Account.create!(user: @user, account_number: "9999")
    importer = TransactionsImporter.new(credit_file, @user)

    expect(importer.account).to eq account
  end

  it "creates new account w/ valid file name" do
    importer = TransactionsImporter.new(credit_file, @user)
    expect { importer.account }.to change { Account.count }.by 1
    expect(importer.account.account_number).to eq "9999"
  end

  it "allows user to provide account" do
    # file should not match account account based on number
    sample_account = Account.create!(user: @user, account_number: "XXXX")
    importer = TransactionsImporter.new(credit_file, @user, account: sample_account)

    expect(importer.account).to eq sample_account
  end

  it "aborts import if no valid account number" do
    no_account_file = Tempfile.new("fake_file.csv")
    no_account_file.close
    importer = TransactionsImporter.new(no_account_file, @user)
    expect(importer.account).to be_nil
    expect { importer.import_file_data }.to raise_error(RuntimeError) 
  end

  it "allows user to provider transaction/account type" do
    importer = TransactionsImporter.new(credit_file, @user, type: "Credit")
    expect(importer.transaction_type).to eq "CreditTransaction"
    expect(importer.account_type).to eq "CreditAccount"
  end

  it "does not allow invalid types" do
    debit_importer = TransactionsImporter.new(credit_file, @user, type: "Debit")
    expect(debit_importer.transaction_type).to eq "DebitTransaction"
    savings_importer = TransactionsImporter.new(credit_file, @user, type: "Savings")
    expect(savings_importer.transaction_type).to eq "SavingsTransaction"
    expect {
      TransactionsImporter.new(credit_file, @user, type: "Other")
    }.to raise_error RuntimeError
  end

  it "assigns nil type if none provided" do
    importer = TransactionsImporter.new(debit_file, @user)
    expect(importer.transaction_type).to be_nil
    expect(importer.account_type).to be_nil
  end

  it "creates new records" do
  end

  it "updates existing records" do
  end

  it "removes extra whitespace from rows" do
  end
end