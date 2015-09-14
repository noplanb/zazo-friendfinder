class Score::Criterias::FriendOfFriends < Score::Criterias::Base
  def self.ratio
    16
  end

  def calculate
    @friends = contact.zazo_mkey ? get_friends : []
    @friends.size
  end

  private

  def get_friends
    StatisticsApi.new(user_mkey: contact.owner, contact_mkey: contact.zazo_mkey).users :friends_are_friends_with_contact
  rescue Faraday::ClientError
    []
  end
end
