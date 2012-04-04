jQuery ->
  SEARCH_URL = "http://search.twitter.com/search.json?callback=?"

  handle_this = (tweets) ->
    for tweet in tweets
      do (tweet) ->
        tweet_element = "<div class='tweet'><p>#{tweet.text}</p></div>"
        $("#tweets_feeder").append(tweet_element)
    

  cycle_this = ->
    $("#tweets_feeder").cycle
      fx:     'scrollDown'
      easing: 'easeOutBounce'
      delay:  -2000
 
  get_tweets = ->
    $("#tweets_feeder").fadeOut("fast")
    $("#tweets_feeder").fadeIn("fast")
    $.getJSON "#{SEARCH_URL}",
      q: "#{gon.hashtag}"
      include_entities: true, 
      (tweets) ->
        console.log tweets
        handle_this tweets.results
        cycle_this()
  
  get_tweets()
  
  setInterval (->
    get_tweets()
  ), 180000

