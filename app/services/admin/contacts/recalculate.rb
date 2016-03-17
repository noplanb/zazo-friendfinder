class Admin::Contacts::Recalculate < Admin::Contacts
  def do
    if Score::CalculationByContact.new(@contact).do
      [true, 'Score was recalculated']
    else
      [false, 'Something was wrong']
    end
  end
end
