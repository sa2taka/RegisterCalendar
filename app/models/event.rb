class Event < ApplicationRecord
  has_many :members, dependent: :destroy

  validates :start, presence: true
  validates :end, presence: true
end
