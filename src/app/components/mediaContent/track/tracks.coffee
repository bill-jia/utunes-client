app = angular.module "uTunes"

app.controller("TrackIndexController", ["$scope", "TrackService", "AlbumService",
  ($scope, TrackService, AlbumService) ->
    TrackService.listTracks().then((tracks) ->
      $scope.tracks = tracks
      # console.log $scope.tracks.length
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
      {
        name: 'Audio'
        field: 'audio'
      }
      {
        name: 'Edit'
        field: 'edit'
      }
    ]
    $scope.count = 25
])

app.controller("TrackEditController", ["$scope", "$state", "$stateParams", "TrackService",
  ($scope, $state, $stateParams, TrackService) ->
    TrackService.getTrack($stateParams.trackId).then((track) ->
      # console.dir track
      $scope.track = track
      track.artists = TrackService.getArtists(track.id).$object
    )

    $scope.save = () ->
      TrackService.updateTrack($scope.track, $stateParams.trackId).then(() ->
        $state.go("root.tracks.index", {}, {reload: true})
      )

    $scope.delete = () ->
      $scope.track.remove().then(() ->
        $state.go("root.tracks.index", {}, {reload: true})
      )

    $scope.removeArtist = (index) ->
      artist = $scope.track.artists[index]
      if artist.id
        artist.remove_association = true
      else
        $scope.track.artists.splice(index, 1)

    $scope.addArtist = () ->
      $scope.track.artists.push({name: "", class_year: ""})
])

app.config(["$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state "root.tracks",
        name: "tracks"
        abstract: true
        url: "tracks"
        template: "<ui-view/>"
      .state "root.tracks.index",
        name: "tracks.index"
        url: "/"
        templateUrl: "app/components/mediaContent/track/views/index.html"
        controller: "TrackIndexController"
      .state "root.tracks.edit",
        name: "tracks.edit"
        url: "/{trackId}/edit"
        templateUrl: "app/components/mediaContent/track/views/edit.html"
        controller: "TrackEditController"
])
