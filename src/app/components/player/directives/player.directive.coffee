angular.module "uTunes"
  .directive 'audioPlayer', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/player.html'
      controller: ($scope, $element) ->
        audio = $element.find("audio")
        $scope.playing = false
        $scope.shuffle = false
        $scope.repeat = "off"
        $scope.volume = 0.5
        $scope.muted = false

        $scope.$on("selecttrack", (e, audioUrl)->
          console.log "Received"
          console.log audioUrl
          $scope.source = audioUrl
          audio.load()
        )

        pausePlay: () ->
          $scope.playing = !$scope.playing

        setShuffle: () ->
          $scope.shuffle = !$scope.shuffle

        changeMuteState: () ->
          $scope.muted = !$scope.muted

        changeRepeatState: () ->
          if $scope.repeat == "off"
            $scope.repeat = "on"
          else if $scope.repeat == "on"
            $scope.repeat = "once"
          else if $scope.repeat == "once"
            $scope.repeat = "off"

        setVolume: (volume) ->
          $scope.volume = volume
          console.log "player volume = " + $scope.volume
