app = angular.module "uTunes"

app.controller("AlbumIndexController", ["$scope", "AlbumService",
  ($scope, AlbumService, $rootScope) ->
    AlbumService.listAlbums().then((albums) ->
      $scope.albums = albums
    )
])

app.controller("AlbumShowController", ["$scope", "$stateParams", "AlbumService", "TrackService",
  ($scope, $stateParams, AlbumService, TrackService) ->

    AlbumService.getAlbum($stateParams.albumId).then((album) ->
      $scope.album = album
    )
    AlbumService.getTracks($stateParams.albumId).then((tracks) ->
      $scope.tracks = tracks
      for track in $scope.tracks
        track.artists = TrackService.getArtists(track.id).$object
        track.album = AlbumService.getAlbum(track.album_id).$object
    )
    AlbumService.getProducers($stateParams.albumId).then((producers) ->
      $scope.producers = producers
    )

    $scope.headers = [
      {
        name: 'Track Number'
        field: 'track_number'
      }
      {
        name: 'Title'
        field: 'title'
      }
      {
        name: 'Artists'
        field: 'artists'
      }
      {
        name: 'Length'
        field: 'length_in_seconds'
      }
    ]
    $scope.count=25
])

app.controller("AlbumNewController", ["$scope", "$state", "AlbumService",
  ($scope, $state, AlbumService) ->
    $scope.album = {producers:[{name: "", class_year: "", bio: ""}],
    tracks: [{artists: [{name: "", class_year: "", bio: ""}], track_number:"", title: "", length_in_seconds: "", file: ""} ], file: ""}

    $scope.formsValid = false
    $scope.albumEdit = false
    $scope.artistEdit = false
    $scope.producerEdit = false
    $scope.trackEdit = false

    $scope.registerFormScope = (form, id) ->
      $scope.parentForm["childForm" + id] = form
      # console.dir $scope.parentForm

    $scope.save = () ->
      # console.dir $scope.album
      if $scope.parentForm.$valid
        AlbumService.createAlbum($scope.album).then(() ->
          $state.go("root.albums.index", {}, {reload: true})
        )
      $scope.formsValid = $scope.parentForm.$valid

    $scope.addProducer = () ->
      $scope.album.producers.push({name: "", class_year: "", bio: ""})

    $scope.removeProducer = (index, album) ->
      producer = album.producers[index]
      if producer.id
        producer._destroy = true
      else
        album.producers.splice(index,1)

    $scope.addTrack = () ->
      $scope.album.tracks.push({artists: [{name: "", class_year: "", bio: ""}], track_number:"", title: "", length_in_seconds: "", file: ""})

    $scope.removeTrack = (index, album) ->
      track = album.tracks[index]
      if track.id
        track._destroy = true
      else
        album.tracks.splice(index,1)
])

app.controller("AlbumEditController", ["$scope", "$state", "$stateParams", "AlbumService", "TrackService"
  ($scope, $state, $stateParams, AlbumService, TrackService) ->
    AlbumService.getAlbum($stateParams.albumId).then((album) ->
      $scope.album = album
      console.dir $scope.album
    )

    AlbumService.getProducers($stateParams.albumId).then((producers) ->
      $scope.producers = producers
    )

    AlbumService.getTracks($stateParams.albumId).then((tracks) ->
      $scope.tracks = tracks
      for track in $scope.tracks
        track.artists = TrackService.getArtists(track.id).$object
        track.album = AlbumService.getAlbum(track.album_id).$object
    )

    $scope.formsValid = false
    $scope.albumEdit = true
    $scope.artistEdit = false
    $scope.producerEdit = false
    $scope.trackEdit = false

    $scope.registerFormScope = (form, id) ->
      $scope.parentForm["childForm" + id] = form
      # console.dir $scope.parentForm

    $scope.headers = [
      {
        name: 'Track Number'
        field: 'track_number'
      }
      {
        name: 'Title'
        field: 'title'
      }
      {
        name: 'Artists'
        field: 'artists'
      }
      {
        name: 'Length'
        field: 'length_in_seconds'
      }
      {
        name: 'Edit'
        field: 'edit'
      }
    ]

    $scope.count=25

    $scope.addProducer = () ->
      unless $scope.album.producers
        $scope.album.producers = []
      $scope.album.producers.push({name: "", class_year: "", bio: ""})

    $scope.removeProducer = (index, album) ->
      producer = album.producers[index]
      unless producer.id
        album.producers.splice(index,1)

    $scope.removeProducerAssociation = (producer) ->
      producer._remove = true
      unless $scope.album.producers
        $scope.album.producers = []
      $scope.album.producers.push producer

    $scope.addTrack = () ->
      unless $scope.album.tracks
        $scope.album.tracks = []
      $scope.album.tracks.push({artists: [{name: "", class_year: "", bio: ""}], track_number:"", title: "", length_in_seconds: "", file: ""})
      console.dir $scope.album.tracks

    $scope.removeTrack = (index, album) ->
      track = album.tracks[index]
      if track.id
        track._destroy = true
      else
        album.tracks.splice(index,1)

    $scope.save = () ->
      AlbumService.updateAlbum($scope.album, $stateParams.albumId).then(() ->
        $state.go("root.albums.show", {"albumId": $stateParams.albumId})
      )

    $scope.delete = () ->
      $scope.album.remove().then(() ->
        $state.go("root.albums.index", {}, {reload: true})
      )
])

app.config(["$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state "root.albums",
        name: "albums"
        abstract: true
        url: "albums"
        template: "<ui-view/>"
      .state "root.albums.index",
        name: "albums.index"
        url: "/"
        templateUrl: "app/components/mediaContent/album/views/index.html"
        controller: "AlbumIndexController"
      .state "root.albums.show",
        name: "albums.show"
        url: "/{albumId}/show"
        templateUrl: "app/components/mediaContent/album/views/show.html"
        controller: "AlbumShowController"
      .state "root.albums.new",
        name: "albums.new"
        url: "/new"
        templateUrl: "app/components/mediaContent/album/views/new.html"
        controller: "AlbumNewController"
        resolve: {
          auth: ["$auth", ($auth) ->
            return $auth.validateUser()
          ]
          producer: ["trackRoles", (trackRoles) ->
            return trackRoles.producer()
          ]
        }
      .state "root.albums.edit",
        name: "albums.edit"
        url: "/{albumId}/edit"
        templateUrl: "app/components/mediaContent/album/views/edit.html"
        controller: "AlbumEditController"
        resolve: {
          auth: ["$auth", ($auth) ->
            return $auth.validateUser()
          ]
          producer: ["trackRoles", (trackRoles) ->
            return trackRoles.producer()
          ]
        }
])
