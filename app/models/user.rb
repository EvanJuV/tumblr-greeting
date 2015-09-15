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
    followers = []
    offset = 0
    coincidences = 0
    unless blog.list.followers.nil?
      actual_followers = blog.list.followers[0 .. 4]
    end
      
    loop do
      response = client.followers("#{blog.name}.tumblr.com", {:offset => offset})
      unless response["users"].nil?
        offset += 20
        response["users"].each do |u|
          if actual_followers.include? u["name"]
            coincidences += 1
          end
          break if coincidences >= 2
          followers << u["name"]
        end
        break if offset >= 49999 || response["users"].size < 20 || coincidences >= 2
      end
    end
    followers
  end

  def self.new_text_post(title = '', body, user, blog, commit)
  	client = User.prepare_access_token(user)
  	response = client.text("#{blog.name}.tumblr.com",
		{:title => title, :body => body, :format => 'html', :state => commit})
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
        list.update(followers: actual_followers, last_followers: old_followers, 
          new_followers: actual_followers - old_followers)
      else
        actual_followers = User.get_followers(user, b)
        b.list = List.new(followers: actual_followers, last_followers: nil, 
          new_followers: actual_followers)
      end
    end
  end
end