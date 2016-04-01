class Admin::Contacts::UpdateInfo < Admin::Contacts
  def do
    if Contact::Update::FindZazoContact.new(@contact).do &&
       Contact::Update::UpdateZazoInfo.new(@contact).do
      [true, 'Contact info was updated']
    else
      [false, 'Something was wrong']
    end
  end
end
