angular.module "uTunes"
  .directive 'repeatButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope:
        repeat: "="
      templateUrl: 'app/components/player/views/repeat-button.html'
      link: (scope, element, attrs, playerController) ->
        scope.changeRepeatState = () ->
          playerController.changeRepeatState()
