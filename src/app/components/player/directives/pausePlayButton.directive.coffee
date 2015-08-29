angular.module "uTunes"
  .directive 'pausePlayButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/pause-play-button.html'
      link: (scope, element, attrs, playerController) ->
