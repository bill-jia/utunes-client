angular.module "uTunes"
  .directive 'pausePlayButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/pause-play-button.html'
      link: (scope, element, attrs, playerController) ->
        scope.pausePlay = () ->
          playerController.pausePlay()

        element.on "mouseover", (e) ->
          element.addClass "active"

        element.on "mouseleave", (e) ->
          element.removeClass "active"
