angular.module "uTunes"
  .directive 'audioPlayer', ["$interval", ($interval) ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/player.html'
      controller: ($scope, $element) ->
        $scope.audio = $element.find("audio")[0]
        $scope.playing = false
        $scope.shuffle = false
        $scope.repeat = "off"
        $scope.volume = 0.5
        $scope.muted = false
        $scope.currentTime = 0

        timeoutId = $interval(() ->
          $scope.currentTime = $scope.audio.currentTime
          # console.log $scope.currentTime
        , 250)

        $scope.$on("selecttrack", (e, audioUrl)->
          # console.log "Received"
          # console.log audioUrl
          $scope.source = audioUrl
          $scope.audio.load()
          $scope.audio.autoplay = true
          $scope.audio.volume = $scope.volume
          $scope.audio.muted = $scope.muted
        )

        pausePlay: () ->
          if $scope.audio.readyState == 3 || $scope.audio.readyState == 4
            if $scope.playing
              $scope.audio.pause()
            else
              $scope.audio.play()
            $scope.playing = !$scope.playing

        setShuffle: () ->
          $scope.shuffle = !$scope.shuffle

        changeMuteState: () ->
          $scope.muted = !$scope.muted
          $scope.audio.muted = $scope.muted

        changeRepeatState: () ->
          if $scope.repeat == "off"
            $scope.repeat = "on"
          else if $scope.repeat == "on"
            $scope.repeat = "once"
          else if $scope.repeat == "once"
            $scope.repeat = "off"

        setVolume: (volume) ->
          $scope.audio.volume = volume
          $scope.volume = volume
          # console.log "player volume = " + $scope.volume

        setPosition: (position) ->
          $scope.audio.currentTime = position*$scope.audio.duration
          $scope.currentTime = $scope.audio.currentTime
  ]
