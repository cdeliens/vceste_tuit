jQuery ->
  SEARCH_URL = "http://search.twitter.com/search.json?callback=?"
  create_image_html = (entitie) ->
    url = entitie[0].media_url
    image = "<div id='tweet_media'><img src='#{url}'/></div>"

  create_html = (tweet, x, y, z, rotate_x, rotate_y, scale) ->
    open_tweet = "<div class='step' data-x='#{x}' data-y='#{y}' data-z='#{z}' data-rotate-x='#{rotate_x}' data-rotate-y='#{rotate_y}', data-scale='#{scale}'>"
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
    z = 200
    rotate_x = 1
    rotate_y = 1
    scale = 1
    for tweet in tweets
      do (tweet) ->
        append_to_feeder create_html(tweet, x, y, z, rotate_x, rotate_y, scale)
        x += 1000
        y += 1000
        rotate_x = randomFromInterval(0, 360)
        rotate_y = randomFromInterval(0, 360)
        scale = randomFromInterval(1, 10)
        z = randomFromInterval(-1300, 1300)


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
    get_tweets()
  
  unless gon.where == "home"
    append_to_hashtag(get_hashtag())
    init()
    setInterval("window.location.reload()", 120000)

  
  
  

