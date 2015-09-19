angular.module "uTunes"
  .directive 'playingToast', [() ->
    directive =
      restrict: 'E'
      scope: {}
      template: ""
      controller: ($scope, $element, $timeout, $mdToast, $document) ->
        $scope.$on "trackplaying", (e, track) ->
          console.log "A track is playing"
          $mdToast.show({
            controller: ToastController
            templateUrl: "app/components/playingToast/playing-toast.html"
            parent: $document[0].querySelector("playing-toast")
            hideDelay: 0
            locals: {
              trackId: track.id
            }
            position: "bottom right"
          })

  ]

ToastController = ($scope, $mdToast, $mdDialog, TrackService, AlbumService, PlaylistService, trackId) ->
  TrackService.getTrack(trackId).then((track) ->
    $scope.track = track
    $scope.track.album = AlbumService.getAlbum(track.album_id).$object
    $scope.track.artists = TrackService.getArtists(track.id).$object
    console.dir $scope.track
  )

  $scope.$on "trackfinished", (e, track)->
    $mdToast.hide()

  $scope.showPlaylists = (e) ->
    $mdDialog.show({
      controller: DialogController
      templateUrl: 'app/components/trackTable/playlist-dialog.html'
      parent: angular.element(document.body)
      targetEvent: e
      clickOutsideToClose: true
    }).then(
      (playlists)->
        for playlist in playlists
          if !playlist.id
            playlist.tracks = []
            playlist.seed_track_id = $scope.track.id
            PlaylistService.createPlaylist(playlist)
          else
            PlaylistService.addTrackToPlaylist(playlist, $scope.track)
      () ->
        console.log "Dialog closed"
    )

DialogController = ($scope, $mdDialog, PlaylistService) ->
  PlaylistService.getUserPlaylists($scope.$root.user.id).then((playlists) ->
    $scope.playlists = playlists
    $scope.playlists.push {title: "", user_id: $scope.$root.user.id, author: $scope.$root.user.name, wanted: true}
    console.log $scope.playlists.length
  )

  $scope.hide = () ->
    $mdDialog.hide()

  $scope.cancel = () ->
    console.log "Cancel clicked"
    $mdDialog.cancel()

  $scope.answer = () ->
    wantedPlaylists = []
    for playlist in $scope.playlists
      if playlist.wanted and playlist.title
        delete playlist.wanted
        wantedPlaylists.push playlist
    console.dir wantedPlaylists
    $mdDialog.hide(wantedPlaylists)
