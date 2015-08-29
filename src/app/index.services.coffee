app = angular.module 'uTunes'

app.factory("onSelectTrack", ["$rootScope",
  ($rootScope) ->
    broadcast: (audioUrl) ->
      $rootScope.$broadcast("selecttrack", audioUrl)
      console.log "Broadcasted"
      console.log audioUrl
])
