app = angular.module "uTunes"

app.controller("ArtistIndexController", ["$scope", "ArtistService",
  ($scope, ArtistService) ->
    ArtistService.listArtists().then((artists) ->
      $scope.artists = artists
    )
])

app.controller("ArtistShowController", ["$scope", "$stateParams", "ArtistService", "TrackService", "AlbumService",
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

    $scope.headers = [
      {
        name: 'Title'
        field: 'title'
      }
      {
        name: 'Artists'
        field: 'artists'
      }
      {
        name: 'Album'
        field: 'album'
      }
      {
        name: 'Length'
        field: 'length_in_seconds'
      }
      'Artists', 'Album', 'Length', 'Audio'
    ]
    $scope.count = 25
])

app.controller("ArtistEditController", ["$scope", "$state", "$stateParams", "ArtistService",
  ($scope, $state, $stateParams, ArtistService) ->
    ArtistService.getArtist($stateParams.artistId).then((artist) ->
      $scope.artist = artist
    )

    $scope.save = () ->
      ArtistService.updateArtist($scope.artist, $stateParams.artistId).then(() ->
        $state.go("root.artists.show", {"artistId": $stateParams.artistId})
      )

    $scope.delete = () ->
      $scope.artist.remove({delete_associated_tracks: $scope.artist.delete_associated_tracks}).then(() ->
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
