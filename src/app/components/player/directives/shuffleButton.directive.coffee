angular.module "uTunes"
  .directive 'shuffleButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/shuffle-button.html'
      link: (scope, element, attrs, playerController) ->
        scope.setShuffle = () ->
          playerController.setShuffle()
