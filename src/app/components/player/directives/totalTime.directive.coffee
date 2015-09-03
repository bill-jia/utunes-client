angular.module "uTunes"
  .directive 'totalTime', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/total-time.html'
      link: (scope, element, attrs, playerController) ->
