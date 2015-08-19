angular.module "uTunes"
  .controller("AlbumsController", ["$scope", "AlbumService",
    ($scope, AlbumService) ->

      AlbumService.list().then((albums) ->
        $scope.albums = albums
        console.dir albums
      )
  ])
    