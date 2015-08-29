angular.module "uTunes"
  .directive 'audioPlayer', ->
    directive =
      restrict: 'E'
      templateUrl: 'app/components/player/player.html'
      controller: ($scope, $element) ->
        audio = $element.find("audio")
        source = $element.find("source")
        $scope.$on("selecttrack", (e, audioUrl)->
          console.log "Received"
          console.log audioUrl
        )
