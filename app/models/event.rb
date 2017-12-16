class Event < ApplicationRecord
  has_many :event_members, dependent: :destroy
  has_many :members, through: :event_members

  accepts_nested_attributes_for :event_members, allow_destroy: true
  accepts_nested_attributes_for :members

  validates :start, presence: true
  validates :event_date, presence: true
  validates :members, presence: true
end
