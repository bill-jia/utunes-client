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
    ]
    if $scope.user.role && ($scope.user.role == 'admin' || $scope.user.role == 'producer')
      $scope.headers.push {name: "Download", field: "download"}
      $scope.headers.push {name: "Edit", field: "edit"}
    $scope.count = 25
])

app.controller("TrackEditController", ["$scope", "$state", "$stateParams", "AlbumService", "TrackService", "$mdDialog",
  ($scope, $state, $stateParams, AlbumService, TrackService, $mdDialog) ->
    $scope.trackNumbers = []
    TrackService.getTrack($stateParams.trackId).then((track) ->
      $scope.track = track
      AlbumService.getTracks(track.album_id).then((tracks) ->
        for track in tracks
          if track.track_number != $scope.track.track_number
            $scope.trackNumbers.push track.track_number
        console.log $scope.trackNumbers.length
      )
    )

    $scope.formsValid = false
    $scope.albumEdit = false
    $scope.artistEdit = false
    $scope.producerEdit = false
    $scope.trackEdit = true

    $scope.registerFormScope = (form, id) ->
      $scope.parentForm["childForm" + id] = form
      # console.dir $scope.parentForm

    $scope.save = () ->
      $scope.formSending = true
      TrackService.updateTrack($scope.track, $stateParams.trackId).then(() ->
        $state.go("root.tracks.index", {}, {reload: true})
      )

    $scope.delete = () ->
      $scope.formSending = true
      $scope.track.remove().then(() ->
        $state.go("root.tracks.index", {}, {reload: true})
      )

    $scope.openDeleteDialog = (e) ->
      $mdDialog.show({
          controller: TrackDeleteDialogController
          templateUrl: "app/components/mediaContent/track/views/delete-dialog.html"
          parent: angular.element(document.body)
          targetEvent: e
          clickOutsideToClose: true
      }).then(
        (answer) ->
          $scope.delete()
        () ->
      )

])

TrackDeleteDialogController = ["$scope", "$mdDialog", ($scope, $mdDialog) ->
  $scope.hide = () ->
    $mdDialog.hide()

  $scope.cancel = () ->
    $mdDialog.cancel()

  $scope.answer = (answer) ->
    $mdDialog.hide(answer)
]

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
        resolve: {
          auth: ["$auth", ($auth) ->
            return $auth.validateUser()
          ]
          producer: ["trackRoles", (trackRoles) ->
            return trackRoles.producer()
          ]
        }
])
