class Member < ApplicationRecord
  has_many :event_members
  has_many :events, through: :event_members
end
