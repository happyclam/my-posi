CONSUMER_KEY = ENV['CONSUMER_KEY'] || Settings.twitter.consumer_key
CONSUMER_SECRET = ENV['CONSUMER_SECRET'] || Settings.twitter.consumer_secret

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter,
    CONSUMER_KEY,
    CONSUMER_SECRET,
    display: 'popup'

  # provider :facebook,
  #   Settings.facebook.app_id,
  #   Settings.facebook.app_secret,
  #   display: 'popup'

  # provider :google_oauth2,
  #   Settings.google.client_id,
  #   Settings.google.client_secret,
  #   {
  #     name: "google",
  #     scope: "userinfo.profile",
  #     approval_prompt: 'auto'
  #   }

  # provider :yahoojp,
  #   Settings.yahoojp.app_id,
  #   Settings.yahoojp.app_secret,
  #   {
  #     scope: "openid profile"
  #   }

  # provider :mixi,
  #   Settings.mixi.consumer_key,
  #   Settings.mixi.consumer_secret,
  #   info_level: :min

end

# Twitter.configure do |config|
#   config.consumer_key = TWITTER_CONSUMER_KEY
#   config.consumer_secret = TWITTER_CONSUMER_SECRET
#   config.oauth_token = TWITTER_OAUTH_TOKEN
#   config.oauth_token_secret = TWITTER_OAUTH_SECRET
# end
