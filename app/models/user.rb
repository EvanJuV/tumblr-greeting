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
  	response = client.followers("#{blog.name}.tumblr.com", {:limit => 1})
    users_count = response["total_users"]
    followers = []
    offset = 0

    while users_count > 0
      response = client.followers("#{blog.name}.tumblr.com", {:offset => offset})
      followers << response["users"].map {|u| u["name"]}
      offset += 20
      users_count -= 20
    end

    followers
  end

  def self.new_text_post(title = '', body, user, blog, commit)
  	client = User.prepare_access_token(user)
  	response = client.text("#{blog.name}.tumblr.com",
		{:title => title, :body => body, :format => 'html', :state => commit})
    logger.info response
    response['status'] ? false : true
  end

  def self.new_image_post(image, caption = '', user, blog, commit)
    client = User.prepare_access_token(user)
    client.photo("#{blog.name}.tumblr.com", 
    {:data => [image], :caption => caption, :format => 'html', :state => commit})
    response['status'] ? false : true
  end

  def self.update_followers(user)
    user.blogs.each do |b|
      if b.list
        list = b.list
        old_followers = list.followers
        actual_followers = User.get_followers(user, b)
        list.update(followers: actual_followers, last_followers: old_followers, new_followers: actual_followers - old_followers)
      else
        actual_followers = User.get_followers(user, b)
        b.list = List.new(followers: actual_followers, last_followers: nil, new_followers: actual_followers)
      end
    end
  end
end  