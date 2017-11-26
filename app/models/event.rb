class Event < ApplicationRecord
  has_many :members, inverse_of: :event
  accepts_nested_attributes_for :members, allow_destroy: true

  validates :start, presence: true
  validates :end, presence: true
end
