class User < ActiveRecord::Base  
	has_many :blogs

  def self.create_with_omniauth(response)  
    create! do |user|  
      logger.info response
      user.provider = response["provider"]  
      user.uid = response["uid"]  
      user.name = response["info"]["name"]
      user.token = response.credentials.token
      user.secret = response.credentials.secret

      response.extra.raw_info.blogs.each do |b|
        new_blog = Blog.new(name: b.name)
        user.blogs << new_blog
      end
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

  def self.get_followers(user, blog)
  	client = User.prepare_access_token(user)
  	response = client.followers("#{blog.name}.tumblr.com")
  	response["users"].map {|u| u["name"]}
  end

  def self.new_text_post(title = '', body, user, blog)
  	client = User.prepare_access_token(user)
  	response = client.text("#{blog.name}.tumblr.com",
		{:title => title, :body => body, :format => 'html'})
    logger.info response
    if response['status']
      false
    end
  end

  def self.new_image_post(image, caption = '', user, blog)
    client = User.prepare_access_token(user)
    client.photo("#{blog.name}.tumblr.com", 
    {:data => [image], :caption => caption, :format => 'html'})
    if response['status']
      false
    end
  end
end  