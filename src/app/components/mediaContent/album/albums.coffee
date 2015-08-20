app = angular.module "uTunes"

app.controller("AlbumIndexController", ["$scope", "AlbumService",
  ($scope, AlbumService) ->
    AlbumService.listAlbums().then((albums) ->
      $scope.albums = albums
      )
])

app.controller("AlbumShowController", ["$scope", "$stateParams", "AlbumService",
  ($scope, $stateParams, AlbumService) ->

    AlbumService.getAlbum($stateParams.albumId).then((album) ->
      $scope.album = album
    )
])

app.controller("AlbumNewController", ["$scope", "$state", "AlbumService",
  ($scope, $state, AlbumService) ->
    # $scope.album = {}
    $scope.save = () -> AlbumService.post($scope.album).then((data) ->
        $state.go("root.albums.index", {}, {reload: true})
    )
])

app.controller("AlbumEditController", ["$scope", "$state", "$stateParams", "AlbumService",
  ($scope, $state, $stateParams, AlbumService) ->
    AlbumService.getAlbum($stateParams.albumId).then((album) ->
      $scope.album = album
    )

    $scope.save = () ->
      $scope.album.put().then(() ->
        $state.go("root.albums.show", {"albumId": $stateParams.albumId})
      )

    $scope.delete = () ->
      $scope.album.remove().then(() ->
        $state.go("root.albums.index", {}, {reload: true})
      )
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
        controller: "AlbumIndexController"
      .state "root.albums.show",
        name: "albums.show"
        url: "/{albumId}/show"
        templateUrl: "app/components/mediaContent/album/views/show.html"
        controller: "AlbumShowController"
      .state "root.albums.new",
        name: "albums.new"
        url: "/new"
        templateUrl: "app/components/mediaContent/album/views/new.html"
        controller: "AlbumNewController"
      .state "root.albums.edit",
        name: "albums.edit"
        url: "/{albumId}/edit"
        templateUrl: "app/components/mediaContent/album/views/edit.html"
        controller: "AlbumEditController"
])