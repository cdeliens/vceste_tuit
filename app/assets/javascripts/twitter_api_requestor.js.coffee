jQuery ->
  SEARCH_URL = "http://search.twitter.com/search.json?callback=?"

  create_image_html = (entitie) ->
    url = entitie[0].media_url
    image = "<img scr='http://placekitten.com/50/50' width='50px' height='50px'/>"

  create_html = (tweet, x, y) ->
    open_tweet = "<div id='bored' class='step slide' data-x='#{x}' data-y='#{y}'>"
    close_tweet = "</q></div>"
    tweet_text = "<q>#{tweet.text}"
    unless tweet.entities.media is undefined
      console.log tweet.entities.media
      media = tweet.entities.media
      tweet_text += create_image_html(media)
    tweet_element = open_tweet + tweet_text + close_tweet

  pop_up_author = (tweet) ->
    hashtag = "<div>#{gon.hashtag}</div>"
    owner_element = "<div id='owner'><img src='http://placekitten.com/50/50'/><span>@#{tweet.from_user}</span><span>#{hashtag}</span></div>"

  append_to_feeder = (element) ->
    $("#impress").append(element)

  append_to_owner_list = (element) ->
    $("#owner_list").append(element)

  cycle_this = (element, scroll) ->
    $(element).cycle
      fx:     scroll
      easing: 'easeOutBounce'
      delay:  -3000

  handle_this = (tweets) ->
    x = -1000
    y = -1500
    for tweet in tweets
      do (tweet) ->
        append_to_feeder create_html(tweet, x, y)
        x += -1000

  
  get_tweets = ->
    $("#tweets_feeder").fadeOut("fast")
    $("#tweets_feeder").fadeIn("fast")
    $.getJSON("#{SEARCH_URL}",
      q: "#{gon.hashtag}"
      include_entities: true, 
      (tweets) ->
        console.log tweets
        handle_this tweets.results
    ).success(->
      impress().init()
      setInterval(impress().next(), 100)
    ).error(->
      alert "error"
    )
        
  
  get_tweets()
  
  

