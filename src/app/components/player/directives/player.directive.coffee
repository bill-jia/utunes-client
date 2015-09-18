angular.module "uTunes"
  .directive 'audioPlayer', ["$interval", ($interval) ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/player/views/player.html'
      controller: ($scope, $element, onTrackPlaying) ->
        $scope.playing = false
        $scope.shuffle = false
        $scope.repeat = "off"
        $scope.volume = 0.5
        $scope.muted = false
        $scope.currentTime = 0
        $scope.currentIndex = 0
        $scope.stopIndex = 0
        $scope.canRewind = false
        $scope.canFastForward = false
        $scope.duration = 0

        $scope.audio = $element.find("audio")[0]
        $scope.audio.autoplay = true
        $scope.audio.volume = $scope.volume
        $scope.audio.muted = $scope.muted

        timeoutId = $interval(() ->
          $scope.currentTime = $scope.audio.currentTime
        , 250)

        $scope.$on("selecttrack", (e, tracks, includeIndexInShuffle)->
          $scope.trackList = tracks
          $scope.shuffledTrackList = shuffle($scope.trackList, includeIndexInShuffle)
          if $scope.shuffle
            $scope.queue = $scope.shuffledTrackList
          else
            $scope.queue = $scope.trackList
          loadTrack(0)
        )

        loadTrack = (index) ->
          $scope.currentIndex = index
          $scope.source = $scope.queue[index].audio.url
          $scope.currentTime = 0
          $scope.audio.load()
          updateCanFastForward()
          updateCanRewind()
          onTrackPlaying.broadcast($scope.queue[index])

        updateCanFastForward = () ->
          if $scope.repeat == "off" && ($scope.currentIndex+1)%$scope.queue.length == $scope.stopIndex
            $scope.canFastForward = false
          else
            $scope.canFastForward = true

        updateCanRewind = () ->
          if $scope.repeat == "off" && $scope.currentIndex == $scope.stopIndex
            $scope.canRewind = false
          else
            $scope.canRewind = true

        shuffle = (array, includeIndexInShuffle) ->
          if includeIndexInShuffle
            arrayCopy = array.slice(0)
          else
            arrayCopy = array.slice(1)
          shuffledArray = []
          if !includeIndexInShuffle
            shuffledArray.push array[0]
          for i in [arrayCopy.length..1]
            j = Math.floor(Math.random()*i)
            shuffledArray.push arrayCopy[j]
            arrayCopy.splice(j, 1)
          shuffledArray

        $scope.audio.onended = (e) ->
          if $scope.repeat == "once"
            $scope.audio.load()
          else
            if $scope.canFastForward
              $scope.$apply(loadTrack(($scope.currentIndex+1)%$scope.queue.length))

        $scope.audio.onloadedmetadata = (e) ->
          $scope.$apply($scope.duration = $scope.audio.duration)

        pausePlay: () ->
          if $scope.audio.readyState == 3 || $scope.audio.readyState == 4
            if $scope.playing
              $scope.audio.pause()
            else
              $scope.audio.play()
            $scope.playing = !$scope.playing

        setShuffle: () ->
          $scope.shuffle = !$scope.shuffle
          currentTrack = $scope.queue[$scope.currentIndex]
          if $scope.shuffle
            $scope.queue = $scope.shuffledTrackList
          else
            $scope.queue = $scope.trackList
          $scope.currentIndex = $scope.queue.indexOf(currentTrack)
          $scope.stopIndex = $scope.currentIndex

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
          updateCanFastForward()
          updateCanRewind()

        setVolume: (volume) ->
          $scope.audio.volume = volume
          $scope.volume = volume

        setPosition: (position) ->
          $scope.audio.currentTime = position*$scope.audio.duration
          $scope.currentTime = $scope.audio.currentTime

        fastForward: () ->
          if $scope.canFastForward
            loadTrack(($scope.currentIndex+1)%$scope.queue.length)


        rewind: () ->
          if $scope.canRewind
            loadTrack(($scope.queue.length + $scope.currentIndex - 1)%$scope.queue.length)

  ]
