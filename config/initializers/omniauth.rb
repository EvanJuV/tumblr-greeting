Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :tumblr, Figaro.env.tumblr_key, Figaro.env.tumblr_secret  
end  