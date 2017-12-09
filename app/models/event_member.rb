class EventMember < ApplicationRecord
  belongs_to :event
  belongs_to :member  

  accepts_nested_attributes_for :event, reject_if: :all_blank
end
