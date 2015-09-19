app = angular.module "uTunes"

app.directive 'playlistTable', ["PlaylistService", (PlaylistService) ->
  directive =
    restrict: 'E'
    scope:
      content: '='
      headers: '='
      count: '='
    templateUrl: "app/components/mediaContent/playlist/playlist-table.html"
    controller: ["$scope", "$filter", "$window", "onSelectTrack", "PlaylistService",
      ($scope, $filter, $window, onSelectTrack, PlaylistService) ->
        orderBy = $filter('orderBy')
        $scope.tablePage = 0
        sortable =   ["title", "author"]
        # console.dir $scope.content

        $scope.handleSort = (field) ->
          if (sortable.indexOf(field) > -1)
            true
          else
            false

        $scope.order = (predicate, reverse) ->
          if predicate == "artists"
            $scope.content = orderBy($scope.content, orderByArtists, reverse)
          else if predicate == "album"
            $scope.content = orderBy($scope.content, orderByAlbum, reverse)
          else
            $scope.content = orderBy($scope.content, predicate, reverse)

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
          Math.ceil($scope.content.length/$scope.count)

        $scope.getNumber = (number) ->
          new Array(number)

        $scope.goToPage = (page) ->
          $scope.tablePage = page

        $scope.playPlaylist = (id) ->
          PlaylistService.getTracks(id).then((tracks) ->
            console.dir tracks
            onSelectTrack.broadcast(tracks, 0, true)
          )
    ]
]
app.filter('startFrom', () ->
  (input, start) ->
    start = +start
    input.slice start
)
