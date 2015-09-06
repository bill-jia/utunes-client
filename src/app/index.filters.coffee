angular.module "uTunes"
  .filter("cut", ()->
    (value, wordwise, max, tail, linkTo) ->
      if !value
        return ''
      max = parseInt(max, 10)
      if !max
        return value
      if value.length <= max
        return value
      value = value.substr(0, max)
      if wordwise
        lastspace = value.lastIndexOf(' ')
        if lastspace != -1
          value = value.substr(0, lastspace)
      value + "<a href='" + linkTo + "'>" + (tail or '…') + "</a>"
  )
