angular.module "uTunes"
  .directive 'volumeBar', ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/volume-bar.html'
      link: (scope, element, attrs, playerController) ->
        element.on "mouseover", (e) ->
          element.addClass "active"

        element.on "mouseleave", (e) ->
          element.removeClass "active"
