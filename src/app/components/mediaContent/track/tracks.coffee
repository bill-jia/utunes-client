app = angular.module "uTunes"

app.controller("TrackIndexController", ["$scope", "TrackService",
  ($scope, TrackService) ->
    TrackService.listTracks().then((tracks) ->
      $scope.tracks = tracks
      )
])

app.controller("TrackEditController", ["$scope", "$state", "$stateParams", "TrackService",
  ($scope, $state, $stateParams, TrackService) ->
    TrackService.getTrack($stateParams.trackId).then((track) ->
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