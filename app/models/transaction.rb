class Transaction < ApplicationRecord
  belongs_to :account
  validates :account, presence: true
  validates_uniqueness_of :description,
                          scope: %i[account_id posting_date balance]

  def self.upsert(params)
    params.symbolize_keys!
    if params[:posting_date].present?
      params[:posting_date] = Date.strptime(params[:posting_date], '%m/%d/%Y')
    end
    find_or_initialize_by(
      params.slice(:description, :account_id, :posting_date, :balance)
    ).update!(
      params
    )
  end
end
