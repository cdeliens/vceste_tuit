Region = ->
  @id = 0
  @name = 0
  @type = ""
  @x
  @y

addRegion = (id, name, type, x, y) ->
  region = new Region
  region.id = id
  region.name = name
  region.type = type
  region.x = x
  region.y = y
  regions.push region
  invalidate()

init = ->
  canvas = document.getElementById("canvas")
  HEIGHT = canvas.height
  WIDTH = canvas.width
  document.onmousedown = onDocumentMouseDown
  document.onmouseup = onDocumentMouseUp
  document.onmousemove = onDocumentMouseMove
  document.addEventListener "touchstart", onDocumentTouchStart, false
  document.addEventListener "touchmove", onDocumentTouchMove, false
  document.addEventListener "touchend", onDocumentTouchEnd, false
  window.addEventListener "deviceorientation", onWindowDeviceOrientation, false
  worldAABB = new b2AABB()
  worldAABB.minVertex.Set -200, -200
  worldAABB.maxVertex.Set screen.width + 200, screen.height + 200
  world2 = new b2World(worldAABB, new b2Vec2(0, 0), true)
  world = new b2World(worldAABB, new b2Vec2(0, 9.8), true)
  setWalls()
  reset()
  region = getRelease("1")
  history[0] = region
  lasttype = "release"
  getRegion region.id
  bodiescrum = regions
  $("#browser_ghost").mouseup ->
    body = getBodyAtMouse()
    div = ""
    type = body.m_userData.type
    if body?
      i = 0
      while i < bodies.length
        if bodies[i] is body
          body = bodies[i]
          div = body.m_userData.div
          id = body.m_userData.id
          name = body.m_userData.name
          bodies.splice i, 1
          elements.splice i, 1
          clearInBrownCircle div
          inBrowseCircle id, type, name
          region.id = body.m_userData.id
          region.name = body.m_userData.name
          region.type = body.m_userData.type
          region.x = centerX
          region.y = centerY
          switch type
            when "release"
              getRegion id
              bodiescrum = regions
              drawNoGravityNodes "region"
              newregion = new Region()
              newregion.id = body.m_userData.id
              newregion.name = body.m_userData.name
              newregion.type = body.m_userData.type
              newregion.x = centerX
              newregion.y = centerY
              history[0] = newregion
            when "region"
              getLocalities id
              newregion = new Region()
              newregion.id = body.m_userData.id
              newregion.name = body.m_userData.name
              newregion.type = body.m_userData.type
              newregion.x = centerX
              newregion.y = centerY
              history[1] = newregion
              drawNoGravityNodes "localitie"
            when "localitie"
              newregion = new Region()
              newregion.id = body.m_userData.id
              newregion.name = body.m_userData.name
              newregion.type = body.m_userData.type
              newregion.x = centerX
              newregion.y = centerY
              history[2] = newregion
        i++

  $("#browser_ghost").click ->
    switch lasttype
      when "release"
        style = CIRCLE_STYLE
        lastregion = history[0]
        clearNodes "release", bodiescrum
      when "region"
        style = CIRCLE_STYLE
        lastregion = history[0]
      when "localitie"
        style = CIRCLE_SON_STYLE
        lastregion = history[1]
    createBallPositioned lastregion, style, centerX, centerY


createfistlevel = (type, release) ->
  switch type
    when "region"
      style = CIRCLE_STYLE
      browseCircle "release", (centerX * 2) - 100, 100, release.name
      $("#browser_release").bind "mousedown", ->
        $("#browser_release").fadeOut "fast", ->

        createBallPositioned lastregion, style, (centerX * 2) - 100, 100
    when "localitie"
      style = CIRCLE_STYLE
      browseCircle "release", (centerX * 2) - 100, 100, release.name
      $("#browser_release").bind "mousedown", ->
        $("#browser_release").fadeOut "fast", ->

        createBallPositioned lastregion, style, (centerX * 2) - 100, 100


clearNodes = (type, bodiescrum) ->
  switch type
    when "release"
      style = CIRCLE_SON_STYLE
      bodieslenght = bodies.length
      body = undefined
      $("#browser_release").remove()
      i = 0
      while i < bodiescrum.length
        $("#ball_" + bodiescrum[i].name).remove()
        i++
      i = 0
      while i < bodieslenght
        if bodies[i].m_userData.type = "release"
          body = bodies[i]
          world.DestroyBody body
        i++
    when "region"
      style = CIRCLE_SON_STYLE
      bodieslenght = bodies.length
      body = undefined
      $("#browser_release").remove()
      i = 0
      while i < bodiescrum.length
        $("#ball_" + bodiescrum[i].name).delay(100 * i).remove()
        i++
      i = 0
      while i < bodieslenght
        body = bodies[i]
        world.DestroyBody body
        i++
    when "localitie"
      style = CIRCLE_SON_STYLE
      bodieslenght = bodies.length
      body = undefined
      $("#browser_release").remove()
      i = 0
      while i < bodiescrum.length
        $("#ball_" + bodiescrum[i].name).delay(100 * i).remove()
        i++
      i = 0
      while i < bodieslenght
        body = bodies[i]
        world.DestroyBody body
        i++




addNodeEvent = (region, id, type) ->
  switch type
    when "region"
      style = CIRCLE_SON_STYLE
      $("#browser_" + region).bind "mousedown", ->
        createSonBalls regions, style
        i = 0
        while i < regions.length
          $("#browser_" + regions[i].name).remove()
          i++
    when "localitie"
      style = CIRCLE_STYLE_MINI
      $("#browser_" + region).bind "mousedown", ->
        createSonBalls regions, style
        i = 0
        while i < regions.length
          $("#browser_" + regions[i].name).remove()
          i++

      break



clearInBrownCircle = (div) ->
  $("#inbrowsecircle").remove()
  $("#ball_center").remove()
  $("#browser_release").remove()
  i = 0
  while i < 10
    $("#" + div).remove()
    i++
  i = 0
  while i < regions.length
    $("#browser_" + regions[i].name).delay(50 * i).remove()
    i++
  i = 0
  while i < bodiescrum.length
    $("#browser_" + bodiescrum[i].name).delay(50 * i).remove()
    i++
  drop = true  if bodiescrum.length > 0
  setTimeout "drop=false;", 2500



inBrowseCircle = (id, type, name) ->
  radio = 50
  release = new Region()
  release.type = type
  release.name = name
  release.id = id
  inBrowseCircleID = id
  element = browseCircle(type, centerX, centerY, name)
  element.id = "inbrowsecircle"
  $("#canvas").append element
  lasttype = type
  $("#inbrowsecircle").bind "mousedown", ->
    $("#inbrowsecircle").remove()
    style = undefined
    clearregion = undefined
    switch region.type
      when "release"
        style = CIRCLE_STYLE
        clearregion = "region"
        createCenterBalls region, style
      when "region"
        style = CIRCLE_SON_STYLE
        clearregion = "localite"
        createCenterBalls region, style
        createSonBallsPositioned bodiescrum, style, 0, 500
      when "localitie"
        style = CIRCLE_STYLE_MINI
        clearregion = "localite"
        createCenterBalls region, style
        createSonBallsPositioned regions, style, 0, 500
    i = 0
    while i < regions.length
      $("#browser_" + regions[i].name).delay(50 * i).fadeOut "fast", ->
      i++

  $("#inbrowsecircle").mouseup ->
    body = getBodyAtMouse()
    div = ""
    type = body.m_userData.type
    if body?
      i = 0
      while i < bodies.length
        if bodies[i] is body
          body = bodies[i]
          div = body.m_userData.div
          id = body.m_userData.id
          name = body.m_userData.name
          bodies.splice i, 1
          elements.splice i, 1
          clearInBrownCircle div
          inBrowseCircle id, type, name
          region.id = body.m_userData.id
          region.name = body.m_userData.name
          region.type = body.m_userData.type
          region.x = centerX
          region.y = centerY
          switch type
            when "release"
              getRegion id
              bodiescrum = regions
              drawNoGravityNodes "region"
              newregion = new Region()
              newregion.id = body.m_userData.id
              newregion.name = body.m_userData.name
              newregion.type = body.m_userData.type
              newregion.x = centerX
              newregion.y = centerY
              history[0] = newregion
            when "region"
              getLocalities id
              newregion = new Region()
              newregion.id = body.m_userData.id
              newregion.name = body.m_userData.name
              newregion.type = body.m_userData.type
              newregion.x = centerX
              newregion.y = centerY
              history[1] = newregion
              drawNoGravityNodes "localitie"
            when "localitie"
              newregion = new Region()
              newregion.id = body.m_userData.id
              newregion.name = body.m_userData.name
              newregion.type = body.m_userData.type
              newregion.x = centerX
              newregion.y = centerY
              history[2] = newregion
        i++



browseCircle = (type, x, y, region) ->
  switch type
    when "normal"
      size = 300
      opacity = 1
      style = MAIN_CIRCLE_STYLE
      x = x - size / 2
      y = y - size / 2
      font = 12
    when "release"
      size = 180
      opacity = 1
      style = CIRCLE_STYLE
      x = x - size / 2
      y = y - size / 2
      font = 12
    when "ghost"
      size = 300
      opacity = 0
      style = MAIN_CIRCLE_STYLE
      x = x - size / 2
      y = y - size / 2
      font = 12
    when "region"
      size = 130
      opacity = 1
      style = CIRCLE_SON_STYLE
      font = 9
      x = x - size / 2
      y = y - size / 2
      type = region
      font = 12
    when "localitie"
      size = 100
      opacity = 1
      style = CIRCLE_STYLE_MINI
      font = 9
      x = x - size / 2
      y = y - size / 2
      type = region
      font = 12
  element = document.createElement("div")
  element.id = "browser_" + type
  element.style.position = "absolute"
  element.style.left = x + "px"
  element.style.top = y + "px"
  element.style.cursor = "default"
  element.style.opacity = opacity
  element.style.zindex = -1
  element.style.overflow = "visible"
  canvas.appendChild element
  circle = document.createElement("canvas")
  circle.id = "canvas_" + type
  circle.width = size
  circle.height = size
  graphics = circle.getContext("2d")
  graphics.beginPath()
  graphics.arc size * .5, size * .5, size * .5 - 2, 0, PI2, true
  drawPath graphics, style
  showEvent graphics, region, x, y, CIRCLE_FONT
  graphics.closePath()
  element.appendChild circle
  text = document.createElement("div")
  text.onSelectStart = null
  text.innerHTML = "<span style=\"font-size:" + font + "px;\">" + region + "</span>"
  text.style.color = "#555"
  text.style.position = "absolute"
  text.style.left = "0px"
  text.style.top = "0px"
  text.style.fontFamily = "Arial"
  text.style.textAlign = "center"
  element.appendChild text
  text.style.left = ((size - text.clientWidth) / 2) + "px"
  text.style.top = ((size - text.clientHeight) / 2) + "px"
  element


esimpar = (num) ->
  unless num % 2 is 0
    true
  else
    false



drawNoGravityNodes = (type) ->
  x = null
  y = null
  radio = 300
  radioswitch = true
  sumaAngulo = (2 * Math.PI / regions.length)
  i = 0
  while i < regions.length
    if regions.length >= 6
      if radioswitch
        radio = 350
        radioswitch = false
      else
        radio = 250
        radioswitch = true
    angulo += sumaAngulo
    x = radio * Math.cos(angulo)
    y = radio * Math.sin(angulo)
    x += centerX
    y += centerY
    regions[i].x = x
    regions[i].y = y
    browseCircle type, x, y, regions[i].name, regions[i].id
    $("#browser_" + regions[i].name).hide()
    addNodeEvent regions[i].name, regions[i].id, type
    $("#browser_" + regions[i].name).delay(100 * i).fadeIn "fast", ->
    i++



play = ->
  setInterval loop_, 1000 / 40


reset = ->
  i = undefined
  if bodies
    i = 0
    while i < bodies.length
      body = bodies[i]
      canvas.removeChild body.GetUserData().element
      world.DestroyBody body
      body = null
      i++
  bodies = []
  elements = []
  stable_elements = []


onDocumentMouseDown = ->
  isMouseDown = true
  false


onDocumentMouseUp = ->
  isMouseDown = false
  false


onDocumentMouseMove = (event) ->
  mouseX = event.clientX
  mouseY = event.clientY


onDocumentDoubleClick = ->
  reset()


onDocumentTouchStart = (event) ->
  if event.touches.length is 1
    event.preventDefault()
    now = new Date().getTime()
    if now - timeOfLastTouch < 250
      reset()
      return
    timeOfLastTouch = now
    mouseX = event.touches[0].pageX
    mouseY = event.touches[0].pageY
    isMouseDown = true


onDocumentTouchMove = (event) ->
  if event.touches.length is 1
    event.preventDefault()
    mouseX = event.touches[0].pageX
    mouseY = event.touches[0].pageY


onDocumentTouchEnd = (event) ->
  if event.touches.length is 0
    event.preventDefault()
    isMouseDown = false


onWindowDeviceOrientation = (event) ->
  if event.beta
    orientation.x = Math.sin(event.gamma * Math.PI / 180)
    orientation.y = Math.sin((Math.PI / 4) + event.beta * Math.PI / 180)


createInstructions = ->
  size = 180
  element = document.createElement("div")
  element.id = "instructions"
  element.width = size
  element.height = size
  element.style.position = "absolute"
  element.style.left = -200 + "px"
  element.style.top = -200 + "px"
  element.style.cursor = "default"
  element.style.zindex = 1
  element.style.overflow = "visible"
  canvas.appendChild element
  elements.push element
  circle = document.createElement("canvas")
  circle.width = size
  circle.height = size
  graphics = circle.getContext("2d")
  graphics.beginPath()
  graphics.arc size * .5, size * .5, size * .5 - 2, 0, PI2, true
  drawPath graphics, CIRCLE_STYLE
  graphics.closePath()
  element.appendChild circle
  release = new Region
  release = getRelease("1")
  text = document.createElement("div")
  text.onSelectStart = null
  text.innerHTML = "<span style=\"font-size:12px;\">" + release.name + "</span>"
  text.style.color = "#555"
  text.style.position = "absolute"
  text.style.left = "0px"
  text.style.top = "0px"
  text.style.fontFamily = "Arial"
  text.style.textAlign = "center"
  element.appendChild text
  text.style.left = ((size - text.clientWidth) / 2) + "px"
  text.style.top = ((size - text.clientHeight) / 2) + "px"
  b2body = new b2BodyDef()
  circle = new b2CircleDef()
  circle.radius = size / 2
  circle.density = 1
  circle.friction = 0.3
  circle.restitution = 0.3
  b2body.AddShape circle
  b2body.userData =
    element: element
    id: release.id
    type: "MainNode"
    div: element.id
    type: release.type
    name: release.name

  bodies.push world.CreateBody(b2body)
  getRegion release.id


createSonBalls = (regions, style) ->
  size = style.size
  i = 0
  while i < regions.length
    element = document.createElement("div")
    element.id = "ball_" + regions[i].name
    element.width = size
    element.height = size
    element.style.position = "absolute"
    element.style.left = -200 + "px"
    element.style.top = -200 + "px"
    element.style.cursor = "default"
    canvas.appendChild element
    elements.push element
    circle = document.createElement("canvas")
    circle.width = size
    circle.height = size
    graphics = circle.getContext("2d")
    graphics.beginPath()
    graphics.arc size * .5, size * .5, size * .5 - 2, 0, PI2, true
    drawPath graphics, style
    graphics.closePath()
    element.appendChild circle
    text = document.createElement("div")
    text.onSelectStart = null
    text.innerHTML = "<span style=\"font-size:12px;\">" + regions[i].name + "</span>"
    text.style.color = "#555"
    text.style.position = "absolute"
    text.style.left = "0px"
    text.style.top = "0px"
    text.style.fontFamily = "Arial"
    text.style.textAlign = "center"
    element.appendChild text
    text.style.left = ((size - text.clientWidth) / 2) + "px"
    text.style.top = ((size - text.clientHeight) / 2) + "px"
    b2body = new b2BodyDef()
    circle = new b2CircleDef()
    circle.radius = size / 2
    circle.density = 1
    circle.friction = 0.3
    circle.restitution = 0.3
    b2body.AddShape circle
    b2body.userData =
      element: element
      id: regions[i].id
      type: "BabyNode"
      div: element.id
      type: regions[i].type
      name: regions[i].name

    b2body.position.Set regions[i].x, regions[i].y
    b2body.linearVelocity.Set Math.random() * 400 - 200, Math.random() * 400 - 200
    bodies.push world.CreateBody(b2body)
    i++


createSonBallsPositioned = (regions, style, x, y) ->
  size = style.size
  i = 0
  while i < regions.length
    element = document.createElement("div")
    element.id = "ball_" + regions[i].name
    element.width = size
    element.height = size
    element.style.position = "absolute"
    element.style.left = -200 + "px"
    element.style.top = -200 + "px"
    element.style.cursor = "default"
    canvas.appendChild element
    elements.push element
    circle = document.createElement("canvas")
    circle.width = size
    circle.height = size
    graphics = circle.getContext("2d")
    graphics.beginPath()
    graphics.arc size * .5, size * .5, size * .5 - 2, 0, PI2, true
    drawPath graphics, style
    graphics.closePath()
    element.appendChild circle
    text = document.createElement("div")
    text.onSelectStart = null
    text.innerHTML = "<span style=\"font-size:12px;\">" + regions[i].name + "</span>"
    text.style.color = "#555"
    text.style.position = "absolute"
    text.style.left = "0px"
    text.style.top = "0px"
    text.style.fontFamily = "Arial"
    text.style.textAlign = "center"
    element.appendChild text
    text.style.left = ((size - text.clientWidth) / 2) + "px"
    text.style.top = ((size - text.clientHeight) / 2) + "px"
    b2body = new b2BodyDef()
    circle = new b2CircleDef()
    circle.radius = size / 2
    circle.density = 1
    circle.friction = 0.3
    circle.restitution = 0.3
    b2body.AddShape circle
    b2body.userData =
      element: element
      id: regions[i].id
      type: "BabyNode"
      div: element.id
      type: regions[i].type
      name: regions[i].name

    b2body.position.Set x, y
    b2body.linearVelocity.Set Math.random() * 400 - 200, Math.random() * 400 - 200
    bodies.push world.CreateBody(b2body)
    i++


createCenterBalls = (region, style) ->
  size = style.size
  element = document.createElement("div")
  element.id = "ball_center"
  element.width = size
  element.height = size
  element.style.position = "absolute"
  element.style.left = -200 + "px"
  element.style.top = -200 + "px"
  element.style.cursor = "default"
  canvas.appendChild element
  elements.push element
  circle = document.createElement("canvas")
  circle.width = size
  circle.height = size
  graphics = circle.getContext("2d")
  graphics.beginPath()
  graphics.arc size * .5, size * .5, size * .5 - 2, 0, PI2, true
  drawPath graphics, style
  graphics.closePath()
  element.appendChild circle
  text = document.createElement("div")
  text.onSelectStart = null
  text.innerHTML = "<span style=\"font-size:12px;\">" + region.name + "</span>"
  text.style.color = "#555"
  text.style.position = "absolute"
  text.style.left = "0px"
  text.style.top = "0px"
  text.style.fontFamily = "Arial"
  text.style.textAlign = "center"
  element.appendChild text
  text.style.left = ((size - text.clientWidth) / 2) + "px"
  text.style.top = ((size - text.clientHeight) / 2) + "px"
  b2body = new b2BodyDef()
  circle = new b2CircleDef()
  circle.radius = size / 2
  circle.density = 1
  circle.friction = 0.3
  circle.restitution = 0.3
  b2body.AddShape circle
  b2body.userData =
    element: element
    id: region.id
    type: "BabyNode"
    div: element.id
    type: region.type
    name: region.name

  b2body.position.Set region.x, region.y
  b2body.linearVelocity.Set Math.random() * 400 - 200, Math.random() * 400 - 200
  bodies.push world.CreateBody(b2body)



createBallPositioned = (region, style, x, y) ->
  size = style.size
  element = document.createElement("div")
  element.id = "browser_release"
  element.width = size
  element.height = size
  element.style.position = "absolute"
  element.style.left = -200 + "px"
  element.style.top = -200 + "px"
  element.style.cursor = "default"
  canvas.appendChild element
  elements.push element
  circle = document.createElement("canvas")
  circle.width = size
  circle.height = size
  graphics = circle.getContext("2d")
  graphics.beginPath()
  graphics.arc size * .5, size * .5, size * .5 - 2, 0, PI2, true
  drawPath graphics, style
  graphics.closePath()
  element.appendChild circle
  text = document.createElement("div")
  text.onSelectStart = null
  text.innerHTML = "<span style=\"font-size:12px;\">" + region.name + "</span>"
  text.style.color = "#555"
  text.style.position = "absolute"
  text.style.left = "0px"
  text.style.top = "0px"
  text.style.fontFamily = "Arial"
  text.style.textAlign = "center"
  element.appendChild text
  text.style.left = ((size - text.clientWidth) / 2) + "px"
  text.style.top = ((size - text.clientHeight) / 2) + "px"
  b2body = new b2BodyDef()
  circle = new b2CircleDef()
  circle.radius = size / 2
  circle.density = 1
  circle.friction = 0.3
  circle.restitution = 0.3
  b2body.AddShape circle
  b2body.userData =
    element: element
    id: region.id
    type: "BabyNode"
    div: element.id
    type: region.type
    name: region.name

  b2body.position.Set x, y
  b2body.linearVelocity.Set Math.random() * 400 - 200, Math.random() * 400 - 200
  bodies.push world.CreateBody(b2body)


loop = ->
  unless drop
    setWalls()  if getBrowserDimensions()
  else
    dropballs()
  delta[0] += (0 - delta[0]) * .5
  delta[1] += (0 - delta[1]) * .5
  world.m_gravity.x = orientation.x * 350 + delta[0]
  world.m_gravity.y = orientation.y * 350 + delta[1]
  mouseDrag()
  world.Step timeStep, iterations
  i = 0
  while i < bodies.length
    body = bodies[i]
    element = elements[i]
    element.style.left = (body.m_position0.x - (element.width >> 1)) + "px"
    element.style.top = (body.m_position0.y - (element.height >> 1)) + "px"
    i++


createBox = (world, x, y, width, height, fixed) ->
  fixed = true  if typeof (fixed) is "undefined"
  boxSd = new b2BoxDef()
  boxSd.density = 1.0  unless fixed
  boxSd.extents.Set width, height
  boxBd = new b2BodyDef()
  boxBd.AddShape boxSd
  boxBd.position.Set x, y
  world.CreateBody boxBd


mouseDrag = ->
  if isMouseDown and not mouseJoint
    body = getBodyAtMouse()
    if body
      md = new b2MouseJointDef()
      md.body1 = world.m_groundBody
      md.body2 = body
      md.target.Set mouseX, mouseY
      md.maxForce = 30000 * body.m_mass
      md.timeStep = timeStep
      mouseJoint = world.CreateJoint(md)
      body.WakeUp()
    else
      createMode = true
  unless isMouseDown
    createMode = false
    destroyMode = false
    if mouseJoint
      world.DestroyJoint mouseJoint
      mouseJoint = null
  if mouseJoint
    p2 = new b2Vec2(mouseX, mouseY)
    mouseJoint.SetTarget p2





getBodyAtMouse = ->
  mousePVec = new b2Vec2()
  mousePVec.Set mouseX, mouseY
  aabb = new b2AABB()
  aabb.minVertex.Set mouseX - 1, mouseY - 1
  aabb.maxVertex.Set mouseX + 1, mouseY + 1
  k_maxCount = 10
  shapes = new Array()
  count = world.Query(aabb, shapes, k_maxCount)
  body = null
  i = 0

  while i < count
    if shapes[i].m_body.IsStatic() is false
      if shapes[i].TestPoint(mousePVec)
        body = shapes[i].m_body
        break
    ++i
  body


setWalls = ->
  if wallsSetted
    world.DestroyBody walls[0]
    world.DestroyBody walls[1]
    world.DestroyBody walls[2]
    world.DestroyBody walls[3]
    walls[0] = null
    walls[1] = null
    walls[2] = null
    walls[3] = null
  walls[0] = createBox(world, stage[2] / 2, -wall_thickness, stage[2], wall_thickness)
  walls[1] = createBox(world, stage[2] / 2, stage[3] + wall_thickness, stage[2], wall_thickness)
  walls[2] = createBox(world, -wall_thickness, stage[3] / 2, wall_thickness, stage[3])
  walls[3] = createBox(world, stage[2] + wall_thickness, stage[3] / 2, wall_thickness, stage[3])
  wallsSetted = true


dropballs = ->
  if wallsSetted
    world.DestroyBody walls[0]
    world.DestroyBody walls[1]
    world.DestroyBody walls[2]
    world.DestroyBody walls[3]
    walls[0] = null
    walls[1] = null
    walls[2] = null
    walls[3] = null
  stage[3] = stage[3] + 500
  walls[0] = createBox(world, stage[2] / 2, -wall_thickness, stage[2], wall_thickness)
  walls[1] = createBox(world, stage[2] / 2, stage[3] + wall_thickness, stage[2], wall_thickness)
  walls[2] = createBox(world, -wall_thickness, stage[3] / 2, wall_thickness, stage[3])
  walls[3] = createBox(world, stage[2] + wall_thickness, stage[3] / 2, wall_thickness, stage[3])
  wallsSetted = true


getBrowserDimensions = ->
  changed = false
  unless stage[0] is window.screenX
    delta[0] = (window.screenX - stage[0]) * 50
    stage[0] = window.screenX
    changed = true
  unless stage[1] is window.screenY
    delta[1] = (window.screenY - stage[1]) * 50
    stage[1] = window.screenY
    changed = true
  unless stage[2] is window.innerWidth
    stage[2] = window.innerWidth
    changed = true
  unless stage[3] is window.innerHeight
    stage[3] = window.innerHeight
    changed = true
  changed


clear = (c) ->
  c.clearRect 0, 0, WIDTH, HEIGHT

randRange = (min, max) ->
  randomNum = Math.floor(Math.random() * (max - min + 1)) + min
  randomNum





drawPath = (ctx, style) ->
  randomizer = randRange(1, 8)
  ctx.save()
  if style.fill
    ctx.globalAlpha = 0.6
    ctx.fillStyle = style.fill
    ctx.fill()
    ctx.lineWidth = 0.5
    ctx.strokeStyle = style.stroke
    ctx.stroke()
  ctx.restore()


showEvent = (ctx, str, x, y, fontStyle) ->
  ctx.fillStyle = fontStyle.color
  ctx.font = fontStyle.font
  ctx.shadowBlur = 0
  ctx.shadowOffsetX = 0
  ctx.shadowOffsetY = 0
  ctx.textAlign = "center"
  ctx.beginPath()
  ctx.fillText str, x, y


invalidate = ->
  canvasValid = false


centerX = undefined
centerY = undefined
canvas = undefined
delta = [ 0, 0 ]
stage = [ window.screenX, window.screenY, window.innerWidth, window.innerHeight ]
walls = []
wall_thickness = 200
wallsSetted = false
bodies = undefined
elements = undefined
stable_elements = undefined
text = undefined
bodiescrum = []
createMode = false
destroyMode = false
isMouseDown = false
mouseJoint = undefined
mouseX = 0
mouseY = 0
orientation =
  x: 0
  y: 1

PI2 = Math.PI * 2
timeOfLastTouch = 0
worldAABB = undefined
world = undefined
iterations = 1
timeStep = 1 / 20
WIDTH = undefined
HEIGHT = undefined
angulo = null
region = new Region()
lastregion = null
flag = true
release = undefined
drop = false
history = []
lasttype = undefined
MAIN_CIRCLE_STYLE =
  fill: "rgb(241,75,41)"
  r: "241"
  g: "75"
  b: "41"
  stroke: "rgb(0,0,0)"
  width: .05
  size: 300

CIRCLE_STYLE =
  fill: "rgb(240,240,240)"
  r: "240"
  g: "240"
  b: "240"
  stroke: "rgb(0,0,0)"
  width: .05
  size: 180

CIRCLE_STYLE_MINI =
  fill: "rgb(201,255,184)"
  r: "201"
  g: "255"
  b: "184"
  stroke: "rgb(0,0,0)"
  width: .05
  size: 100

CIRCLE_SON_STYLE =
  fill: "rgb(243,239,122)"
  r: "243"
  g: "239"
  b: "122"
  stroke: "rgb(0,0,0)"
  width: .05
  size: 130

CIRCLE_FONT =
  font: "bold 8pt Courier"
  color: "#555"
  yoffset: 10
  height: 14

$(document).ready ->
  HEIGHT = document.getElementById("canvas").offsetHeight
  WIDTH = document.getElementById("canvas").offsetWidth
  centerX = WIDTH / 2
  centerY = HEIGHT / 2
  radio = 300
  release = new Region
  release.id = "0"
  release.name = ""
  browseCircle "normal", centerX, centerY, ""
  browseCircle "ghost", centerX, centerY

getBrowserDimensions()
init()
play()
inBrowseCircleID = ""