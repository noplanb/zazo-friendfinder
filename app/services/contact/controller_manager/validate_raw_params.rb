class Contact::ControllerManager::ValidateRawParams
  attr_reader :current_user_mkey, :raw_params, :errors

  def initialize(current_user_mkey, raw_params)
    @current_user_mkey = current_user_mkey
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

  def log_messages(status)
    if status == :success
      WriteLog.info(self, "success; current_user: '#{current_user_mkey}'")
    else
      WriteLog.info(self, "failure; current_user: '#{current_user_mkey}'; errors: #{errors.inspect}")
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
