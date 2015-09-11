app = angular.module 'uTunes'

app.controller("SearchResultsController", ["$scope", "AlbumService", "ArtistService", "TrackService", "ProducerService", "$stateParams"
  ($scope, AlbumService, ArtistService, TrackService, ProducerService, $stateParams) ->
    searchParams = $stateParams.searchParams
    console.log searchParams
])

app.config(["$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state "root.search",
        name: "search"
        url: "search/{searchParams}"
        templateUrl: "app/components/search/results.html"
        controller: "SearchResultsController"
])
