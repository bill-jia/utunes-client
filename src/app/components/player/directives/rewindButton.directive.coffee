angular.module "uTunes"
  .directive 'rewindButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/rewind-button.html'
      link: (scope, element, attrs, playerController) ->
