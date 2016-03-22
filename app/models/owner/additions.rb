class Owner::Additions < ActiveRecord::Base
  self.table_name = 'owners'

  validates :mkey, uniqueness: true, presence: true
  validates :unsubscribed, inclusion: [true, false]

  def self.by_mkey(mkey)
    where(mkey: mkey).first
  end
end
