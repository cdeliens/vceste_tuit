jQuery ->
  SEARCH_URL = "http://search.twitter.com/search.json?callback=?"



  create_image_html = (entitie) ->
    url = entitie[0].media_url
    console.log url
    image = "<div id='entitie'><img scr='#{url}'></img></div>"

  pop_up_author = (tweet) ->
    owner_element = "<div id='owner'><img src='http://placekitten.com/50/50'/><span>@#{tweet.from_user}</span></div>"

  append_to_feeder = (element) ->
    $("#tweets_feeder").append(element)

  append_to_owner_list = (element) ->
    $("#owner_list").append(element)

  cycle_this = (element, scroll) ->
    $(element).cycle
      fx:     scroll
      easing: 'easeOutBounce'
      delay:  -2000

  handle_this = (tweets) ->
    for tweet in tweets
      do (tweet) ->
        append_to_feeder create_html(tweet)
        append_to_owner_list pop_up_author(tweet)

  create_html = (tweet) ->
    open_tweet = "<div class='tweet'>"
    close_tweet = "</div>"
    tweet_text = "<p>#{tweet.text}</p>"
    tweet_element = open_tweet + tweet_text + close_tweet
 
  get_tweets = ->
    $("#tweets_feeder").fadeOut("fast")
    $("#tweets_feeder").fadeIn("fast")
    $.getJSON "#{SEARCH_URL}",
      q: "#{gon.hashtag}"
      include_entities: true, 
      (tweets) ->
        console.log tweets
        handle_this tweets.results
        cycle_this("#tweets_feeder", 'scrollDown')
        cycle_this("#owner_list", 'scrollRight')
  
  get_tweets()
  
  setInterval (->
    get_tweets()
  ), 180000

