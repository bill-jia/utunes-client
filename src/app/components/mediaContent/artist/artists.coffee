app = angular.module "uTunes"

app.controller("ArtistIndexController", ["$scope", "ArtistService",
  ($scope, ArtistService) ->
    ArtistService.listArtists().then((artists) ->
      $scope.artists = artists
    )
])

app.controller("ArtistShowController", ["$scope", "$stateParams", "ArtistService", "TrackService", "AlbumService"
  ($scope, $stateParams, ArtistService, TrackService, AlbumService) ->

    ArtistService.getArtist($stateParams.artistId).then((artist) ->
      $scope.artist = artist
    )
    ArtistService.getAlbums($stateParams.artistId).then((albums) ->
      $scope.albums = albums
    )
    ArtistService.getTracks($stateParams.artistId).then((tracks) ->
      $scope.tracks = tracks
      for track in $scope.tracks
        track.album = AlbumService.getAlbum(track.album_id).$object
        track.artists = TrackService.getArtists(track.id).$object
    )
])

app.controller("ArtistEditController", ["$scope", "$state", "$stateParams", "ArtistService",
  ($scope, $state, $stateParams, ArtistService) ->
    ArtistService.getArtist($stateParams.artistId).then((artist) ->
      $scope.artist = artist
    )

    $scope.save = () ->
      $scope.artist.put().then(() ->
        $state.go("root.artists.show", {"artistId": $stateParams.artistId})
      )

    $scope.delete = () ->
      $scope.artist.remove().then(() ->
        $state.go("root.artists.index", {}, {reload: true})
      )
])

app.config(["$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state "root.artists",
        name: "artists"
        abstract: true
        url: "artists"
        template: "<ui-view/>"
      .state "root.artists.index",
        name: "artists.index"
        url: "/"
        templateUrl: "app/components/mediaContent/artist/views/index.html"
        controller: "ArtistIndexController"
      .state "root.artists.show",
        name: "artists.show"
        url: "/{artistId}/show"
        templateUrl: "app/components/mediaContent/artist/views/show.html"
        controller: "ArtistShowController"
      .state "root.artists.edit",
        name: "artists.edit"
        url: "/{artistId}/edit"
        templateUrl: "app/components/mediaContent/artist/views/edit.html"
        controller: "ArtistEditController"
])