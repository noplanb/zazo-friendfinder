class Credentials
  def self.password_for(client)
    ENV["#{client}_password"]
  end
end
