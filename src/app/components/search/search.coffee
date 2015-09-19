app = angular.module 'uTunes'

app.controller("SearchResultsController", [
  "$scope",
  "AlbumService",
  "ArtistService",
  "TrackService",
  "ProducerService",
  "PlaylistService",
  "$stateParams",
  ($scope, AlbumService, ArtistService, TrackService, ProducerService, PlaylistService, $stateParams) ->
    searchParams = $stateParams.searchParams
    $scope.albumsLoaded = false
    $scope.artistsLoaded = false
    $scope.producersLoaded = false
    $scope.tracksLoaded = false
    $scope.playlistsLoaded = false

    AlbumService.searchAlbums(searchParams).then((albums) ->
      $scope.albums = albums
      $scope.albumsLoaded = true
    )

    ProducerService.searchProducers(searchParams).then((producers) ->
      $scope.producers = producers
      $scope.producersLoaded = true
    )

    ArtistService.searchArtists(searchParams).then((artists) ->

      $scope.artists = artists
      $scope.artistsLoaded = true
    )

    PlaylistService.searchPlaylists(searchParams).then((playlists) ->
      $scope.playlists = playlists
      $scope.playlistsLoaded = true
    )

    TrackService.searchTracks(searchParams).then((tracks) ->
      $scope.tracks = tracks

      for track in $scope.tracks
        track.album = AlbumService.getAlbum(track.album_id).$object
        track.artists = TrackService.getArtists(track.id).$object
      $scope.tracksLoaded = true
    )

    $scope.trackHeaders = [
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
    ]
    if $scope.user.role && ($scope.user.role == 'admin' || $scope.user.role == 'producer')
      $scope.trackHeaders.push {name: "Edit", field: "edit"}

    $scope.playlistHeaders = [
      {
        name: "Title"
        field: "title"
      }
      {
        name: "Author"
        field: "author"
      }
    ]

    $scope.trackCount = 25
    $scope.playlistCount = 25
    $scope.albumCount = 6
    $scope.producerCount = 6
    $scope.artistCount = 6
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
