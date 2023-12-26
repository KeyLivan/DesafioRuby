class User < ApplicationRecord
    belongs_to :wallet, dependent: :destroy
end
