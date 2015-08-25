class User < ActiveRecord::Base  
	has_one :list

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
    Tumblr.configure do |config|
      config.consumer_key = Figaro.env.tumblr_key
      config.consumer_secret = Figaro.env.tumblr_secret
      config.oauth_token = user.token
      config.oauth_token_secret = user.secret
    end

    client = Tumblr::Client.new
  end

  def self.get_followers(user)
  	client = User.prepare_access_token(user)
  	response = client.followers("#{user.uid}.tumblr.com")
  	response["users"].map {|u| u["name"]}
  end

  def self.new_text_post(title = '', body, user)
  	client = User.prepare_access_token(user)
  	response = client.text("#{user.uid}.tumblr.com",
		{:title => title, :body => body, :format => 'html'})
    logger.info response
    if response['status']
      false
    end
  end

  def self.new_image_post(image, caption, user)
    client = User.prepare_access_token(user)
    client.photo("#{user.uid}.tumblr.com", 
    {:data => [image], :caption => caption, :format => 'html'})
    if response['status']
      false
    end
  end
end  