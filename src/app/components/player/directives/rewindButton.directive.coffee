angular.module "uTunes"
  .directive 'rewindButton', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/rewind-button.html'
      link: (scope, element, attrs, playerController) ->
        element.on "mouseover", (e) ->
          element.addClass "active"

        element.on "mouseleave", (e) ->
          element.removeClass "active"
