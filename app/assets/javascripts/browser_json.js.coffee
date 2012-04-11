getJSON_discovr = (id, type) ->
  result = null
  switch type
    when ("release")
      URL_json = "url=" + API_URL + RELEASE_CALL
    when ("region")
      URL_json = "url=" + API_URL + REGION_CALL + id
    when ("localitie")
      URL_json = "url=" + API_URL + LOCALITIE_CALL + id
  proxy = "ba-simple-proxy.php"
  url = proxy + "?" + URL_json
  if /mode=native/.test(url)
    $.get url, (data) ->
  else
    $.ajax
      url: url
      dataType: "json"
      async: false
      success: (data) ->
        result = data
  result
getJSON_discovrASync = (id, type) ->
  result = null
  switch type
    when ("release")
      URL_json = "url=" + API_URL + RELEASE_CALL
    when ("region")
      URL_json = "url=" + API_URL + REGION_CALL + id
    when ("localitie")
      URL_json = "url=" + API_URL + LOCALITIE_CALL + id
  proxy = "ba-simple-proxy.php"
  url = proxy + "?" + URL_json
  if /mode=native/.test(url)
    $.get url, (data) ->
  else
    $.getJSON url, (data) ->
      result = data
  result
getRelease = (id) ->
  type = "release"
  id = 1
  result = getJSON_discovr(id, type)
  region = new Region
  region = json_release(result, region)
  region
getRegion = (id) ->
  type = "region"
  result = getJSON_discovr(id, type)
  regions = new Array()
  json_regions result
getLocalities = (id) ->
  type = "localitie"
  result = getJSON_discovr(id, type)
  regions = new Array()
  json_localities result
json_localities = (o) ->
  type = typeof o
  if type is "object"
    for key of o.contents.localities
      addRegion o.contents.localities[key].id, o.contents.localities[key].name, "localitie"  if o.contents.localities[key].id?
      json_localities o[key]
json_regions = (o) ->
  type = typeof o
  if type is "object"
    for key of o.contents.regions
      addRegion o.contents.regions[key].id, o.contents.regions[key].name, "region"  if o.contents.regions[key].id?
      json_regions o[key]
json_release = (o, region) ->
  region.id = o.contents[0].id
  region.name = o.contents[0].name
  region.type = "release"
  region
API_URL = "http%3A%2F%2Fsamiqnet.appspot.com%2Fapi"
RELEASE_CALL = "%2Frelease"
REGION_CALL = "%2Frelease%3Fid%3D"
LOCALITIE_CALL = "%2Frelease%2Fregion%3Fid%3D"