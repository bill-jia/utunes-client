app = angular.module "uTunes"

app.directive 'trackTable', () ->
  directive =
    restrict: 'E'
    scope:
      tracks: '='
      headers: '='
      count: '='
    templateUrl: "app/components/trackTable/track-table.html"
    controller: ($scope, $filter, $window, $mdDialog, onSelectTrack, PlaylistService) ->
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
      $scope.order("title", false)
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
        onSelectTrack.broadcast($scope.tracks, index + $scope.tablePage*$scope.count)

      originatorEv = null
      $scope.menuOptions =[
        [
          "Add to Playlist", ($event) ->
            $scope.showPlaylists($event, $scope.menuTrack)
        ]
      ]

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
          locals: {
            three: 3
          }
        }).then(
          (playlists)->
            for playlist in playlists
              PlaylistService.addTrackToPlaylist(playlist, $scope.menuTrack)
          () ->
            console.log "Dialog closed"
        )

      $scope.$on "trackplaying", (e, track) ->
        console.log "Track playing"
        $scope.playingTrack = track
        console.log $scope.playingTrack.id
app.filter('startFrom', () ->
  (input, start) ->
    start = +start
    input.slice start
)

# app.directive('mdColresize', ($timeout) ->
#   restrict: "A",
#   link: (scope, element, attrs) ->
#     scope.$evalAsync( ()->
#       $timeout(()->
#         $(element).colResizable(
#           liveDrag: true
#           fixed: true
#         )
#       ,100)
#     )
# )

DialogController = ($scope, $mdDialog, PlaylistService) ->
  PlaylistService.getUserPlaylists($scope.$root.user.id).then((playlists) ->
    $scope.playlists = playlists
    console.dir $scope.playlists
  )

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
    console.dir wantedPlaylists
    $mdDialog.hide(wantedPlaylists)
