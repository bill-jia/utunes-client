app = angular.module "uTunes"

app.controller("PlaylistIndexController", ["$scope", "PlaylistService", "$state",
  ($scope, PlaylistService, $state) ->
    PlaylistService.listPlaylists().then((playlists) ->
      $scope.playlists = playlists
    )
    $scope.headers = [
      {
        name: "Title"
        field: "title"
      }
      {
        name: "Author"
        field: "author"
      }
    ]
    $scope.count = 25
])

app.controller("PlaylistShowController", ["$scope", "PlaylistService", "AlbumService", "TrackService", "$stateParams",
  ($scope, PlaylistService, AlbumService, TrackService, $stateParams) ->
    PlaylistService.getPlaylist($stateParams.playlistId).then((playlist) ->
      $scope.playlist = playlist
    )
    PlaylistService.getTracks($stateParams.playlistId).then((tracks) ->
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
    ]
    $scope.$watch('user', (newValue)->
      if $scope.user.role && ($scope.user.role == 'admin' || $scope.user.role == 'producer')
        $scope.headers.push {name: "Download", field: "download"}
    , true)
    $scope.count = 25
])

app.controller("PlaylistNewController", ["$scope", "PlaylistService", "$state",
  ($scope, PlaylistService, $state) ->
    $scope.formSending = false
    $scope.playlist = {title: "", user_id: $scope.user.id, author: $scope.user.name, is_public: false}
    $scope.save = () ->
      $scope.formSending = true
      PlaylistService.createPlaylist($scope.playlist).then(() ->
        $state.go("root.playlists.index", {}, {reload: true})
      )
])

app.controller("PlaylistEditController", ["$scope", "PlaylistService", "$stateParams", "$state", "AlbumService", "TrackService", "$mdDialog",
  ($scope, PlaylistService, $stateParams, $state, AlbumService, TrackService, $mdDialog) ->
    $scope.formSending = false
    PlaylistService.getPlaylist($stateParams.playlistId).then((playlist) ->
      $scope.playlist = playlist
    )
    PlaylistService.getTracks($stateParams.playlistId).then((tracks) ->
      $scope.tracks = tracks
      for track in $scope.tracks
        track.album = AlbumService.getAlbum(track.album_id).$object
        track.artists = TrackService.getArtists(track.id).$object
        track._remove = false
      $scope.playlist.tracks = $scope.tracks
      console.dir $scope.playlist
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
        name: 'Remove'
        field: 'remove'
      }
    ]
    $scope.count = 25


    $scope.save = () ->
      $scope.formSending = true
      PlaylistService.updatePlaylist($scope.playlist, $stateParams.playlistId).then(() ->
        $state.go("root.playlists.index", {}, {reload: true})
        # $state.go("root.playlists.show", {"playlistId": $stateParams.playlistId})
      )

    $scope.openDeleteDialog = (e) ->
      $mdDialog.show({
          controller: PlaylistDeleteDialogController
          templateUrl: "app/components/mediaContent/playlist/views/delete-dialog.html"
          parent: angular.element(document.body)
          targetEvent: e
          clickOutsideToClose: true
      }).then(
        (answer) ->
          $scope.delete()
        () ->
      )

    $scope.delete = () ->
      $scope.formSending = true
      $scope.playlist.remove().then(() ->
        $state.go("root.playlists.index", {}, {reload: true})
      )
])

PlaylistDeleteDialogController = ($scope, $mdDialog) ->
  $scope.hide = () ->
    $mdDialog.hide()

  $scope.cancel = () ->
    $mdDialog.cancel()

  $scope.answer = (answer) ->
    $mdDialog.hide(answer)

app.config(["$stateProvider", ($stateProvider) ->
  $stateProvider
    .state "root.playlists",
      name: "playlists"
      abstract: true
      url: "playlists"
      template: "<ui-view/>",
    .state "root.playlists.index",
      name: "playlists.index"
      url: "/"
      templateUrl: "app/components/mediaContent/playlist/views/index.html"
      controller: "PlaylistIndexController"
    .state "root.playlists.show",
      name: "playlists.show"
      url: "/{playlistId}/show"
      templateUrl: "app/components/mediaContent/playlist/views/show.html"
      controller: "PlaylistShowController"
    .state "root.playlists.new",
      name: "playlists.new"
      url: "/new"
      templateUrl: "app/components/mediaContent/playlist/views/new.html"
      controller: "PlaylistNewController"
    .state "root.playlists.edit",
      name: "playlists.edit"
      url: "/{playlistId}/edit"
      templateUrl: "app/components/mediaContent/playlist/views/edit.html"
      controller: "PlaylistEditController"
])
