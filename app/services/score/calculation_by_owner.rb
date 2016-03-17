class Score::CalculationByOwner
  attr_reader :owner

  def initialize(owner_mkey)
    @owner = Owner.new(owner_mkey)
  end

  def do
    owner.contacts.map do |contact|
      Score::CalculationByContact.new(contact).do
    end.find { |res| !res }.nil? ? true : false
  end
end
