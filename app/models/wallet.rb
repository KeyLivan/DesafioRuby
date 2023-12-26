class Wallet < ApplicationRecord
    has_one :user, dependent: :destroy
    has_many :users
    has_many :transactions, dependent: :destroy
end
