angular.module "uTunes"
  .directive 'fastForwardButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/fast-forward-button.html'
      link: (scope, element, attrs, playerController) ->

        element.on "mouseover", (e) ->
          element.addClass "active"

        element.on "mouseleave", (e) ->
          element.removeClass "active"
