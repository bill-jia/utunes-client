app = angular.module "uTunes"

app.filter("cut", ()->
  (value, wordwise, max, tail, linkTo) ->
    if !value
      return ''
    max = parseInt(max, 10)
    if !max
      return value
    if value.length <= max-1
      return value
    value = value.substr(0, max-1)
    if wordwise
      lastspace = value.lastIndexOf(' ')
      if lastspace != -1
        value = value.substr(0, lastspace)
    if linkTo
      value + "<a href='" + linkTo + "'>" + (tail or '…') + "</a>"
    else
      value + (tail or '…')
)

app.filter("time", () ->
  (value) ->
    seconds = value / 1000
    hours = Math.floor(seconds/3600)
    minutes = Math.round((seconds - hours*3600)/60)
    output = ""
    if hours > 0
      output += hours
      output += " h "
    output += minutes
    output += " m"
    output
)

app.filter('startFrom', () ->
  (input, start) ->
    start = +start
    input.slice start
)
