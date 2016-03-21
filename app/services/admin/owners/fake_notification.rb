class Admin::Owners::FakeNotification < Admin::Owners
  def do
    if contact
      Notification::Create.new(:fake_user_joined, contact).do.each { |n| n.send_notification }
      [true, 'Notifications was created and sent']
    else
      [false, 'No contact to notify']
    end
  end

  private

  def contact
    @contact ||= owner.contacts.suggestible.first
  end
end
