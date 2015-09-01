angular.module "uTunes"
  .directive 'pausePlayButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/pause-play-button.html'
      link: (scope, element, attrs, playerController) ->
        scope.pausePlay = () ->
          playerController.pausePlay()

        element.bind "mouseover", (e) ->
          element.addClass "active"

        element.bind "mouseleave", (e) ->
          element.removeClass "active"

        scope.audio.onplay = (e) ->
          if !scope.playing
            playerController.pausePlay()
