class User < ActiveRecord::Base  
	has_one :list
	require "oauth"
	require "omniauth-tumblr"

  def self.create_with_omniauth(auth)  
    create! do |user|  
      user.provider = auth["provider"]  
      user.uid = auth["uid"]  
      user.name = auth["info"]["name"]
      user.token = auth.credentials.token
      user.secret = auth.credentials.secret  
    end  
  end

  def self.prepare_access_token(user)
  	consumer = OAuth::Consumer.new("wUoVuaj6WJbMe4jLT1JXx1Pv14F8weXKm4cIXIGX1G1UKzde6R", "zDCLgZ4sLx82GY08kMbf9JHUUHHtNtlJU4eSPKS6RvlvQ6jypY",
  	{:site => "http://www.tumblr.com/"})
  	token_hash = {:oauth_token => user.token, :oauth_token_secret => user.secret}
  	access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def self.get_followers(user)
  	access_token = User.prepare_access_token(user)
  	response = access_token.get("http://api.tumblr.com/v2/blog/#{user.uid}.tumblr.com/followers")
  	JSON.parse(response.body)
  end
end  