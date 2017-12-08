class Event < ApplicationRecord
  has_many :members, inverse_of: :event, through: :event_members
  has_many :event_members, dependent: :destroy

  accepts_nested_attributes_for :event_members, allow_destroy: true
  accepts_nested_attributes_for :members

  validates :start, presence: true
  validates :event_date, presence: true
end
