require 'rails_helper'
# HACK: to load STI files -- surely a better way to handle this
Dir['app/models/transactions/*.rb'].each { |f| load f }

RSpec.describe TransactionsImporter do
  before do
    @user = User.create(
      name: 'Test User', email: 'sample@test.com',
      password: 'foobar', password_confirmation: 'foobar'
    )
  end

  let(:credit_file) { file_fixture('Chase9999_sample_credit_activity.csv') }
  let(:debit_file) { file_fixture('Chase9999_sample_debit_activity.csv') }
  let(:savings_file) { file_fixture('Chase9999_sample_savings_activity.csv') }

  it 'determines account from file' do
    account = Account.create!(user: @user, account_number: '9999')
    importer = TransactionsImporter.new(credit_file, @user)

    expect(importer.account).to eq account
  end

  it 'creates new account w/ valid file name' do
    importer = TransactionsImporter.new(credit_file, @user)
    expect { importer.account }.to change { Account.count }.by 1
    expect(importer.account.account_number).to eq '9999'
  end

  it 'allows user to provide account' do
    # file should not match account account based on number
    sample_account = Account.create!(user: @user, account_number: 'XXXX')
    importer = TransactionsImporter.new(credit_file, @user, account: sample_account)

    expect(importer.account).to eq sample_account
  end

  it 'aborts import if no valid account number' do
    no_account_file = Tempfile.new('fake_file.csv')
    no_account_file.close
    importer = TransactionsImporter.new(no_account_file, @user)
    expect(importer.account).to be_nil
    expect { importer.import_file_data }.to raise_error(RuntimeError)
  end

  it 'allows user to provider transaction/account type' do
    importer = TransactionsImporter.new(credit_file, @user, type: 'Credit')
    expect(importer.transaction_type).to eq 'CreditTransaction'
    expect(importer.account_type).to eq 'CreditAccount'
  end

  it 'does not allow invalid types' do
    debit_importer = TransactionsImporter.new(credit_file, @user, type: 'Debit')
    expect(debit_importer.transaction_type).to eq 'DebitTransaction'
    savings_importer = TransactionsImporter.new(credit_file, @user, type: 'Savings')
    expect(savings_importer.transaction_type).to eq 'SavingsTransaction'
    expect do
      TransactionsImporter.new(credit_file, @user, type: 'Other')
    end.to raise_error RuntimeError
  end

  it 'assigns nil type if none provided' do
    importer = TransactionsImporter.new(debit_file, @user)
    expect(importer.transaction_type).to be_nil
    expect(importer.account_type).to be_nil
  end

  it 'creates new records' do
    importer = TransactionsImporter.new(savings_file, @user)
    expect { importer.import_file_data }.to change { Transaction.count }.by 5
  end

  it 'updates existing records' do
    importer = TransactionsImporter.new(debit_file, @user)
    importer.import_file_data
    expect(Transaction.count).to eq 5

    sample_change = Transaction.first
    sample_change.update(amount: 50_000)
    importer.import_file_data
    sample_change.reload
    expect(sample_change.amount).not_to eq 50_000
  end

  it 'creates records with given type' do
    importer = TransactionsImporter.new(debit_file, @user, type: 'Debit')
    importer.import_file_data

    expect(DebitTransaction.count).to eq 5
  end

  it 'removes extra whitespace from rows' do
    # first row of /spec/fixtures/files/Chase9999_sample_credit_activity.csv has
    # extra spaces in details column
    TransactionsImporter.new(credit_file, @user).import_file_data
    extra_space_fields = Transaction.pluck(:description).select do |desc|
      desc.match(/\s{2,}/)
    end

    expect(extra_space_fields.length).to eq 0
  end
end
