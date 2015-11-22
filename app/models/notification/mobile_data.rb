class Notification::MobileData < Notification::Data
  def get
    { subject: '',
      body: object.compiled_content }
  end
end
