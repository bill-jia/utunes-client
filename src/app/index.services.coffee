app = angular.module 'uTunes'

app.factory("onSelectTrack", ["$rootScope",
  ($rootScope) ->
    broadcast: (tracks, index, includeIndexInShuffle) ->
      processedTracks = []
      for i in [index..tracks.length-1]
        processedTracks.push tracks[i]
      if index != 0
        for i in [0..index-1]
          processedTracks.push tracks[i]
      $rootScope.$broadcast("selecttrack", processedTracks, includeIndexInShuffle)

])

app.factory("onTrackPlaying", ["$rootScope",
  ($rootScope) ->
    broadcast: (track) ->
      $rootScope.$broadcast("trackplaying", track)
])

app.factory("trackRoles", ["$q", "$timeout", "$rootScope"
  ($q, $timeout, $rootScope) ->
    user = $rootScope.user
    admin: () ->
      # console.dir user
      deferred = $q.defer()
      $timeout(() ->
        if user.role == "admin"
          deferred.resolve(user)
        else
          deferred.reject("User is not an admin")
      ,500)
      deferred.promise
    producer: () ->
      # console.dir user
      deferred = $q.defer()
      $timeout(() ->
        if user.role == "producer" || user.role == "admin"
          deferred.resolve(user)
        else
          deferred.reject("User is not a producer")
      ,500)
      deferred.promise
    user: () ->
      # console.dir user
      deferred = $q.defer()
      $timeout(() ->
        if user.role == "user" || user.role == "producer" || user.role == "admin"
          deferred.resolve(user)
        else
          deferred.reject("User is not a user")
      ,500)
      deferred.promise
])
