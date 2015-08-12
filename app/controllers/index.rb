get '/' do
	@twitter_user = TwitterUser.find_by_username(session[:username])
	erb :index
end

post '/' do
	@twitter_user = TwitterUser.find_by_username(session[:username])
	# byebug shows that on index erb, params = {tweet => XXX}, because variable is tweet
	@twitter_user.post_tweet(params["lol"])
	# $client.update(params[:newtweet])
	# @twitter_user.fetch_tweets(params['username'])
	# unless @twitter_user.tweet_still_valid?
	# 	@twitter_user.fetch_tweets
	# else
	# 	@twitter_user.fetch_tweets	
	# end
	@twitter_user.fetch_tweets #no matter what, it loads up new tweets
	@tweets = @twitter_user.tweets
	erb :tweets_show, layout: false
end


get '/auth/twitter/callback' do
	env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorised')
	# byebug
	@twitter_user = TwitterUser.find_or_create_by(username: env['omniauth.auth']['info']['nickname'])
	@access_token = env['omniauth.auth']['credentials']['token']
	@access_secret = env['omniauth.auth']['credentials']['secret']
	# byebug
	@twitter_user.access_token = @access_token
	@twitter_user.access_token_secret = @access_secret
	@twitter_user.save
	
	session[:username] = @twitter_user.username
	redirect '/'
end

get '/auth/failure' do
	params[:message]
end

get '/login' do
	session[:admin] = true
	redirect to ("/auth/twitter")
end

get '/logout' do
	# session[:admin].clear
	# session[:username].clear
	session.clear
	redirect '/'
end






# get '/:username' do
#   @twitter_user = TwitterUser.find_or_create_by(username: params['username'])
#   @tweets = @twitter_user.tweets

#   if @tweets.empty?
#     @twitter_user.fetch_tweets(params['username'])
#   elsif @tweets.last.still_valid?
#     @tweets = @twitter_user.tweets.all
#   else
#     @twitter_user.fetch_tweets(params['username'])
#   end
#   erb :tweet_show

# end


# post '/username' do
#   redirect to "/#{params[:username]}"
# end


# post '/' do
#   $client.update(params[:newtweet])
#   @twitter_user = TwitterUser.find_or_create_by(username: params['username'])
#   @twitter_user.fetch_tweets(params['username'])
#   @tweets = @twitter_user.tweets
#   erb :_tweet_box, layout: false
# end
