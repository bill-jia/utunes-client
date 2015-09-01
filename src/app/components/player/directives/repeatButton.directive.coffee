angular.module "uTunes"
  .directive 'repeatButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/repeat-button.html'
      link: (scope, element, attrs, playerController) ->
        scope.changeRepeatState = () ->
          playerController.changeRepeatState()
