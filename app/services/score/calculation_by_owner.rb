class Score::CalculationByOwner
  attr_reader :owner

  def initialize(owner)
    @owner = Owner.new(owner)
  end

  def do
    owner.contacts.map do |contact|
      Score::CalculationByContact.new(contact).do
    end.find { |res| !res }.nil? ? true : false
  end
end
