app = angular.module "uTunes"

app.controller("AlbumsController", ["$scope", "AlbumService",
  ($scope, AlbumService) ->
    AlbumService.list().then((albums) ->
      $scope.albums = albums
      console.dir albums
      )
])

app.controller("AlbumController", ["$scope", "AlbumService",
  ($scope, AlbumService) ->
])

app.config(["$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state "root.albums",
        name: "albums"
        abstract: true
        url: "albums"
        template: "<ui-view/>"
      .state "root.albums.index",
        name: "albums.index"
        url: "/"
        templateUrl: "app/components/mediaContent/album/views/index.html"
        controller: "AlbumsController"
      .state "root.albums.show",
        name: "albums.show"
        url: "/{albumId}/show"
        templateUrl: "app/components/mediaContent/album/views/show.html"
        controller: "AlbumController"
])