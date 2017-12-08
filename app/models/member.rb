class Member < ApplicationRecord
  validates :name, uniqueness: true
  has_many :event_members, dependent: :destroy
  has_many :events, through: :event_members
end
