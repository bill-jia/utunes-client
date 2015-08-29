angular.module "uTunes"
  .directive 'audioPlayer', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/player.html'
      controller: ($scope, $element) ->
        audio = $element.find("audio")

        $scope.$on("selecttrack", (e, audioUrl)->
          console.log "Received"
          console.log audioUrl
          $scope.source = audioUrl
          audio.load()
        )
