class Member < ApplicationRecord
  has_many :event_members, dependent: :destroy
  has_many :events, through: :event_members

  validates :name, uniqueness: true
end
