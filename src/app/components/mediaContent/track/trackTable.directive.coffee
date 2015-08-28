app = angular.module "uTunes"

app.directive 'trackTable', () ->
  directive =
    restrict: 'E'
    scope:
      tracks: '='
      headers: '='
      count: '='
    templateUrl: "app/components/mediaContent/track/track-table.html"
    controller: ($scope, $filter, $window) ->
      orderBy = $filter('orderBy')
      sortable =   ["track_number", "title", "artists", "album", "length_in_seconds"]

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

app.filter('startFrom', () ->
  (input, start) ->
    start = +start
    input.slice start
)
