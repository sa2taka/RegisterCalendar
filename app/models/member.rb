class Member < ApplicationRecord
  validates :name, uniqueness: true
  has_many :event_members
  has_many :events, through: :event_members
end
