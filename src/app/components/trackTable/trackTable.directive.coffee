app = angular.module "uTunes"

app.directive 'trackTable', () ->
  directive =
    restrict: 'E'
    scope:
      tracks: '='
      headers: '='
      count: '='
    templateUrl: "app/components/trackTable/track-table.html"
    controller:["$scope", "$filter", "$window", "$mdDialog", "onSelectTrack", "PlaylistService", "TrackService", "rfc4122", "$timeout",
      ($scope, $filter, $window, $mdDialog, onSelectTrack, PlaylistService, TrackService, rfc4122, $timeout) ->
        orderBy = $filter('orderBy')
        $scope.tablePage = 0
        $scope.playingTrack = null
        $scope.reverse = false
        $scope.predicate = null
        $scope.tracksLoaded = false
        # console.dir $scope.tracks

        $scope.handleSort = (field) ->
          sortable = ["track_number", "title", "artists", "album", "length_in_seconds"]
          if (sortable.indexOf(field) > -1)
            true
          else
            false

        $scope.order = (predicate, reverse) ->
          if predicate == "artists"
            $scope.tracks = orderBy($scope.tracks, orderByArtists, reverse)
          else if predicate == "album"
            $scope.tracks = orderBy($scope.tracks, orderByAlbum, reverse)
          else if predicate == "track_number"
            $scope.tracks = orderBy($scope.tracks, orderByTrackNumber, reverse)
          else if predicate == "title"
            $scope.tracks = orderBy($scope.tracks, orderByTitle, reverse)
          else
            $scope.tracks = orderBy($scope.tracks, orderByLength, reverse)

          $scope.predicate = predicate
        
        $scope.$watch 'tracks', () ->
          console.log $scope.tracksLoaded
          if $scope.tracksLoaded == false and $scope.tracks
            $scope.tracksLoaded = true
            console.log $scope.reverse
            $timeout(() ->
              $scope.order("track_number", $scope.reverse)
            )

        orderByArtists = (track) ->
          artistArray = []
          for artist in track.artists
            artistArray.push artist.name
          artistArray

        orderByAlbum = (track) ->
          track.album.title

        orderByTrackNumber = (track) ->
          track.track_number

        orderByTitle = (track) ->
          track.title

        orderByLength = (track) ->
          track.length_in_seconds

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
    ]

DialogController = ["$scope", "$mdDialog", "PlaylistService", ($scope, $mdDialog, PlaylistService) ->
  PlaylistService.getUserPlaylists($scope.$root.user.id).then((playlists) ->
    $scope.playlists = playlists
  )

  $scope.newPlaylist = {title: "", user_id: $scope.$root.user.id, author: $scope.$root.user.name, is_public: false, wanted: true}


  $scope.hide = () ->
    $mdDialog.hide()

  $scope.cancel = () ->
    console.log "Cancel clicked"
    $mdDialog.cancel()

  $scope.answer = () ->
    wantedPlaylists = []
    for playlist in $scope.playlists
      if playlist.wanted
        delete playlist.wanted
        wantedPlaylists.push playlist
    if $scope.newPlaylist.title
      delete $scope.newPlaylist.wanted
      wantedPlaylists.push $scope.newPlaylist
    console.dir wantedPlaylists
    $mdDialog.hide(wantedPlaylists)
]
