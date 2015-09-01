angular.module "uTunes"
  .directive 'rewindButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/rewind-button.html'
      link: (scope, element, attrs, playerController) ->
        scope.rewind = () ->
          playerController.rewind()

        element.bind "mouseover", (e) ->
          element.addClass "active"

        element.bind "mouseleave", (e) ->
          element.removeClass "active"
