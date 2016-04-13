class DispatchEvent
  attr_reader :caller, :name, :members

  def initialize(caller, name, members)
    @caller = caller
    @name = name
    @members = members
  end

  def do
    Zazo::Tools::EventDispatcher.emit(name, build_event)
  end

  private

  def build_event
    event = { triggered_by: "ff:#{caller}" }
    event.merge!(build_event_part(:initiator, members.first))
    event.merge!(build_event_part(:target, members.last))
    event.merge(data: build_event_data)
  end

  def build_event_part(type, model)
    return {} unless model
    key = model_to_key(model)
    value = case key
      when 'owner' then model.mkey
      when 'contact' then model.id
      when 'notification' then model.nkey
      else nil
    end
    { type => key, "#{type}_id".to_sym => value }
  end

  def build_event_data
    data = {}
    members.each do |model|
      key = model_to_key(model)
      data.merge!(case key
        when 'contact' then { zazo_mkey: model.zazo_mkey }
        when 'notification' then { category: model.category, contact_id: model.contact_id }
        else {}
      end)
    end
    data.empty? ? nil : data
  end

  def model_to_key(model)
    model.class.to_s.downcase
  end
end
