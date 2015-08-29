angular.module "uTunes"
  .directive 'loopButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/loop-button.html'
      link: (scope, element, attrs, playerController) ->
