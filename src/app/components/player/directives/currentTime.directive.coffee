angular.module "uTunes"
  .directive 'currentTime', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/current-time.html'
      link: (scope, element, attrs, playerController) ->
