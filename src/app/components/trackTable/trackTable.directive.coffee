app = angular.module "uTunes"

app.directive 'trackTable', () ->
  directive =
    restrict: 'E'
    scope:
      tracks: '='
      headers: '='
      count: '='
    templateUrl: "app/components/trackTable/track-table.html"
    controller: ($scope, $filter, $window, $mdDialog, onSelectTrack, PlaylistService, TrackService, rfc4122) ->
      orderBy = $filter('orderBy')
      $scope.tablePage = 0
      $scope.playingTrack = null
      sortable =   ["track_number", "title", "artists", "album", "length_in_seconds"]
      # console.dir $scope.tracks

      $scope.handleSort = (field) ->
        if (sortable.indexOf(field) > -1)
          true
        else
          false

      $scope.order = (predicate, reverse) ->
        if predicate == "artists"
          $scope.tracks = orderBy($scope.tracks, orderByArtists, reverse)
        else if predicate == "album"
          $scope.tracks = orderBy($scope.tracks, orderByAlbum, reverse)
        else
          $scope.tracks = orderBy($scope.tracks, predicate, reverse)

        $scope.predicate = predicate
      $scope.order("track_number", false)
      orderByArtists = (track) ->
        artistArray = []
        for artist in track.artists
          artistArray.push artist.name
        artistArray

      orderByAlbum = (track) ->
        track.album.title

      $scope.numberOfPages = () ->
        Math.ceil($scope.tracks.length/$scope.count)

      $scope.getNumber = (number) ->
        new Array(number)

      $scope.goToPage = (page) ->
        $scope.tablePage = page

      $scope.playTrack = (index, $event) ->
        onSelectTrack.broadcast($scope.tracks, index + $scope.tablePage*$scope.count, false)

      originatorEv = null

      if $scope.$root.user.signedIn
        $scope.menuOptions =[
          [
            "Add to Playlist", ($event) ->
              $scope.showPlaylists($event, $scope.menuTrack)
          ]
        ]

      $scope.downloadFile = (url) ->
        if $scope.$root.user.role == "admin" || $scope.$root.user.role == "producer"
          uid = rfc4122.v4()
          TrackService.postToken(uid).then(()->
            source = "/api/" + url + "?uid=" + uid
            $window.location.assign(source)
          )

      $scope.setMenuTrack = (track) ->
        $scope.menuTrack = track
        console.dir $scope.menuTrack

      $scope.showPlaylists = (e, track) ->
        console.dir $scope.playlists
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
                playlist.seed_track_id = $scope.menuTrack.id
                PlaylistService.createPlaylist(playlist)
              else
                PlaylistService.addTrackToPlaylist(playlist, $scope.menuTrack)
          () ->
            console.log "Dialog closed"
        )

      $scope.$on "trackplaying", (e, track) ->
        $scope.playingTrack = track

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
