app = angular.module 'uTunes'

app.directive 'stopEvent', () ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      if attr and attr.stopEvent
        element.bind attr.stopEvent, (e) ->
          e.stopPropagation()
