app = angular.module "uTunes"

app.controller("AlbumsController", ["$scope", "AlbumService",
  ($scope, AlbumService) ->
    AlbumService.list().then((albums) ->
      $scope.albums = albums
      console.dir albums
      )
])

app.config(["$stateProvider", 
  ($stateProvider) ->
    $stateProvider
      .state "root.albums",
        name: "albums"
        url: "albums"
        templateUrl: "app/components/mediaContent/album/albums.html"
        controller: "AlbumsController" 
])

    
