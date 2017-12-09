module EventsHelper
  def event_data
    data = []

    events = Event.includes(:members)
    events.each do |ev|
      element = {}
      element['date'] = ev.event_date.to_s
      if ev.end
        event_time = "#{Tod::TimeOfDay(ev.start).to_s.slice(0, 5)} 〜 #{Tod::TimeOfDay(ev.end).to_s.slice(0, 5)}"
      else
        event_time = "#{Tod::TimeOfDay(ev.start).to_s.slice(0, 5)} 〜 "
      end

      event_member = ""
      ev.members.each do |member|
        event_member += "#{member.name} "
      end
      element['eventTime'] = event_time
      element['eventMember'] = event_member
      element['color'] = ev.color
      data << element
    end
    data
  end
end
