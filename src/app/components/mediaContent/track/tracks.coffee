app = angular.module "uTunes"

app.controller("TrackIndexController", ["$scope", "TrackService", "AlbumService",
  ($scope, TrackService, AlbumService) ->
    TrackService.listTracks().then((tracks) ->
      $scope.tracks = tracks
      # console.log $scope.tracks.length
      for track, index in $scope.tracks
        albumId = track.album_id
        track.album = AlbumService.getAlbum(albumId).$object
      )
])

app.controller("TrackEditController", ["$scope", "$state", "$stateParams", "TrackService",
  ($scope, $state, $stateParams, TrackService) ->
    TrackService.getTrack($stateParams.trackId).then((track) ->
      # console.dir track
      $scope.track = track
    )

    $scope.save = () ->
      $scope.track.put().then(() ->
        $state.go("root.tracks.index",{}, {reload: true})
      )

    $scope.delete = () ->
      $scope.track.remove().then(() ->
        $state.go("root.tracks.index", {}, {reload: true})
      )
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
