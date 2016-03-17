class Admin::Contacts::UpdateInfo < Admin::Contacts
  def do
    if Contact::SetZazoInfoByContact.new(@contact).do
      [true, 'Contact info was updated']
    else
      [false, 'Something was wrong']
    end
  end
end
