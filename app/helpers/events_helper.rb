module EventsHelper
  def event_data
    data = []

    events = Event.includes(:members)
    events.each do |ev|
      element = {}
      element['date'] = ev.event_date.to_s

      event_name = ""
      event_name += "#{Tod::TimeOfDay(ev.start).to_s} 〜 #{Tod::TimeOfDay(ev.end).to_s}, "
      event_name += "Member:"
      ev.members.each do |member|
        event_name += "#{member.name} "
      end
      element['eventName'] = event_name
      data << element
    end
    data.to_json
  end
end
