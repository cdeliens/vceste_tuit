jQuery ->
  SEARCH_URL = "http://search.twitter.com/search.json?callback=?"
  create_image_html = (entitie) ->
    url = entitie[0].media_url
    image = "<div id='tweet_media'><img src='#{url}'/></div>"

  create_html = (tweet, x, y, z, rotate, scale) ->
    open_tweet = "<div class='step' data-x='#{x}' data-y='#{y}' data-z='#{z}' data-rotate='#{rotate}'>"
    close_tweet = "</q></div>"
    tweet_text = "<q>#{tweet.text}"
    author = pop_up_author tweet
    tweet_element = open_tweet + tweet_text + author
    unless tweet.entities.media is undefined
      console.log tweet.entities.media
      media = tweet.entities.media
      tweet_element += create_image_html(media)
    tweet_element += close_tweet

  get_hashtag = () ->
    gon.hashtag

  pop_up_author = (tweet) ->
    author_image = tweet.profile_image_url
    owner_element = "<div id='owner'><img src='#{author_image}'/><span>@#{tweet.from_user}</span></div>"

  append_to_hashtag = (element) ->
    $("#hashtag").append(element)

  append_to_feeder = (element) ->
    $("#impress").append(element) 

  append_to_owner_list = (element) ->
    $("#owner_list").append(element)

  cycle_this = (element, scroll) ->
    $(element).cycle
      fx:     scroll
      easing: 'easeOutBounce'
      delay:  -3000

  randomFromInterval = (from, to) ->
    Math.floor Math.random() * (to - from + 1) + from

  handle_this = (tweets) ->
    x = 0
    y = 0
    z = 0
    rotate = 0
    scale = 1
    for tweet in tweets
      do (tweet) ->
        append_to_feeder create_html(tweet, x, y, z, rotate, scale)
        x += 1000
        y = randomFromInterval(1000, 5000)
        rotate = randomFromInterval(0, 360)
        scale += 1
        z += randomFromInterval(-300, 300)


  clear_canvas = (element) ->
    $("#impress div").html("")


  handle_success = ->
    setInterval("impress().next()", 6000)

  
  get_tweets = ->
    $.getJSON("#{SEARCH_URL}",
      q: "#{gon.hashtag}"
      include_entities: true, 
      (tweets) ->
        handle_this tweets.results
    ).success(->
      impress().init()
      handle_success()
    ).error(->
      alert "error"
    )

  init = ->
    clear_canvas()
    get_tweets()
  
  refresh_dom = ->

  
  append_to_hashtag(get_hashtag())
  init()
  setInterval("window.location.reload()", 120000)

  
  
  

