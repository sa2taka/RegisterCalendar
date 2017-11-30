class Event < ApplicationRecord
  has_many :members, inverse_of: :event, through: :event_members
  has_many :event_members

  accepts_nested_attributes_for :event_members, allow_destroy: true
  accepts_nested_attributes_for :members

  validates :start, presence: true
  validates :end, presence: true
end
