class Search < ApplicationRecord
  validates :email, presence: true
  validates :date, presence: true
end
