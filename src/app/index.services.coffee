app = angular.module 'uTunes'

app.factory("onSelectTrack", ["$rootScope",
  ($rootScope) ->
    broadcast: (tracks, index) ->
      processedTracks = []
      for i in [index..tracks.length-1]
        processedTracks.push tracks[i]
      if index != 0
        for i in [0..index-1]
          processedTracks.push tracks[i]
      $rootScope.$broadcast("selecttrack", processedTracks)

])

app.factory("onTrackPlaying", ["$rootScope",
  ($rootScope) ->
    broadcast: (track) ->
      $rootScope.$broadcast("trackplaying", track)
])
