# TODO: write some specs

class Contact::ControllerManager::ValidateRawParams
  attr_reader :owner_mkey, :raw_params, :errors

  def initialize(owner_mkey, raw_params)
    @owner_mkey = owner_mkey
    @raw_params = raw_params
    @errors = {}
  end

  def do
    validate_contacts
    return errors.empty?
  rescue => e
    errors[e] = e.message
    return false
  end

  def data
    {}
  end

  def log_messages(status)
    if status == :success
      WriteLog.info(self, "success; owner: '#{owner_mkey}'")
    else
      WriteLog.info(self, "failure; owner: '#{owner_mkey}'; errors: #{errors.inspect}")
    end
  end

  private

  def validate_contacts
    invalid_contacts = raw_params['contacts'].select do |contact|
      !contact['vectors'] || !contact['display_name'] ||
        contact['vectors'].empty? || contact['display_name'].empty?
    end
    errors[:invalid_contacts] = invalid_contacts unless invalid_contacts.empty?
  end
end
