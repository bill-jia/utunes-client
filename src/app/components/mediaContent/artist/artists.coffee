app = angular.module "uTunes"

app.controller("ArtistIndexController", ["$scope", "ArtistService",
  ($scope, ArtistService) ->
    ArtistService.listArtists().then((artists) ->
      $scope.artists = artists.plain()
    )
    $scope.count = 24
])

app.controller("ArtistShowController", ["$scope", "$stateParams", "ArtistService", "TrackService", "AlbumService",
  ($scope, $stateParams, ArtistService, TrackService, AlbumService) ->

    ArtistService.getArtist($stateParams.artistId).then((artist) ->
      $scope.artist = artist
    )
    ArtistService.getAlbums($stateParams.artistId).then((albums) ->
      $scope.albums = albums.plain()
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
    ]
    $scope.trackCount = 25
    $scope.albumCount = 6
    $scope.$watch('user', (newValue)->
      if $scope.user.role && ($scope.user.role == 'admin' || $scope.user.role == 'producer')
        $scope.headers.push {name: "Download", field: "download"}
    , true)
])

app.controller("ArtistEditController", ["$scope", "$state", "$stateParams", "ArtistService", "$mdDialog",
  ($scope, $state, $stateParams, ArtistService, $mdDialog) ->
    ArtistService.getArtist($stateParams.artistId).then((artist) ->
      $scope.artist = artist
    )

    $scope.formsValid = false
    $scope.albumEdit = false
    $scope.artistEdit = true
    $scope.producerEdit = false
    $scope.trackEdit = false

    $scope.registerFormScope = (form, id) ->
      $scope.parentForm["childForm" + id] = form
      console.dir $scope.parentForm

    $scope.save = () ->
      $scope.formSending = true
      ArtistService.updateArtist($scope.artist, $stateParams.artistId).then(() ->
        $state.go("root.artists.show", {"artistId": $stateParams.artistId})
      )

    $scope.openDeleteDialog = (e) ->
      $mdDialog.show({
          controller: ArtistDeleteDialogController
          templateUrl: "app/components/mediaContent/artist/views/delete-dialog.html"
          parent: angular.element(document.body)
          targetEvent: e
          clickOutsideToClose: true
      }).then(
        (answer) ->
          $scope.artist.delete_associated_tracks = answer[0]
          $scope.delete()
        () ->
      )
    $scope.delete = () ->
      $scope.formSending = true
      $scope.artist.remove({delete_associated_tracks: $scope.artist.delete_associated_tracks}).then(() ->
        $state.go("root.artists.index", {}, {reload: true})
      )
])

ArtistDeleteDialogController = ($scope, $mdDialog) ->
  $scope.deleteAssociatedTracks = false
  $scope.hide = () ->
    $mdDialog.hide()

  $scope.cancel = () ->
    $mdDialog.cancel()

  $scope.answer = (answer) ->
    console.log answer
    $mdDialog.hide([answer])

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
        resolve: {
          auth: ["$auth", ($auth) ->
            return $auth.validateUser()
          ]
          producer: ["trackRoles", (trackRoles) ->
            return trackRoles.producer()
          ]
        }
])
