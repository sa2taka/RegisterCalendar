class Member < ApplicationRecord
  belongs_to :event, optional: true

  validates :name, presence: true, uniqueness: true
end
