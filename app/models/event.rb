class Event < ApplicationRecord
  has_many :members

  validates :start, presence: true
  validates :end, presence: true
end
