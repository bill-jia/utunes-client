angular.module "uTunes"
  .directive 'fastForwardButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/fast-forward-button.html'
      link: (scope, element, attrs, playerController) ->
        scope.fastForward = () ->
          playerController.fastForward()

        element.on "mouseover", (e) ->
          element.addClass "active"

        element.on "mouseleave", (e) ->
          element.removeClass "active"
