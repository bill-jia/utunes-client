angular.module "uTunes"
  .directive 'scrubBar', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/scrub-bar.html'
      link: (scope, element, attrs, playerController) ->
