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

  it "allows user to provider transaction type" do
    
  end

  it "attempts to determine transaction type if none given" do
  end

  it "imports without transaction subclass if none found" do
  end

  it "creates new recods" do
  end

  it "updates existing records" do
  end

  it "removes extra whitespace from rows" do
  end
end