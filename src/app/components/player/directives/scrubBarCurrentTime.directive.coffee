angular.module "uTunes"
  .directive 'scrubBarCurrentTime', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/scrub-bar-current-time.html'
      link: (scope, element, attrs, playerController) ->
