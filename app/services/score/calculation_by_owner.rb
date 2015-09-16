class Score::CalculationByOwner
  attr_reader :owner

  def initialize(owner)
    @owner = owner
  end

  def do
    Contact.by_owner(owner).map do |contact|
      Score::CalculationByContact.new(contact).do
    end.find { |res| !res }.nil? ? true : false
  end

  def do_async
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection { |conn| self.do }
    end
  end
end
