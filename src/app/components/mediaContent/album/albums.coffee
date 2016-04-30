app = angular.module "uTunes"

# INDEX all albums from server
app.controller("AlbumIndexController", ["$scope", "AlbumService",
  ($scope, AlbumService, $rootScope) ->
    AlbumService.listAlbums().then((albums) ->
      $scope.albums = albums
    )
    $scope.count = 24
])

# SHOW a single album
app.controller("AlbumShowController", ["$scope", "$stateParams", "AlbumService", "TrackService", "onSelectTrack",
  ($scope, $stateParams, AlbumService, TrackService, onSelectTrack) ->

    # GET the album object
    AlbumService.getAlbum($stateParams.albumId).then((album) ->
      $scope.album = album
    )

    # GET each track from the album
    AlbumService.getTracks($stateParams.albumId).then((tracks) ->
      $scope.tracks = tracks
      for track in $scope.tracks
        # GET each track's associated artists and albums
        track.artists = TrackService.getArtists(track.id).$object
        track.album = AlbumService.getAlbum(track.album_id).$object
    )

    # GET the producers associated with this album
    AlbumService.getProducers($stateParams.albumId).then((producers) ->
      if producers.length > 0
        $scope.producers = producers
    )


    # Set headers for the track table
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

    # If the user is an admin or a producer, add download and edit functionality
    $scope.$watch('user', (newValue)->
      if $scope.user.role && ($scope.user.role == 'admin' || $scope.user.role == 'producer')
        $scope.headers.push {name: "Download", field: "download"}
        $scope.headers.push {name: "Edit", field: "edit"}
    , true)

    # Set initial values for the number of tracks and producers to show
    $scope.trackCount=25
    $scope.producerCount = 6

    # Send the whole album to the player
    $scope.playAlbum = () ->
      onSelectTrack.broadcast($scope.tracks, 0, true)
])

# CREATE new album
app.controller("AlbumNewController", ["$scope", "$state", "AlbumService",
  ($scope, $state, AlbumService) ->
    # Define structure of JSON objects for album and associated tracks, artists, producers
    $scope.album = {producers:[{name: "", class_year: "", bio: ""}],
    tracks: [{artists: [{name: "", class_year: "", bio: ""}], track_number:"", title: "", length_in_seconds: "", file: ""} ], file: ""}
    
    # Create track numbers array to ensure that no repeats occur
    $scope.trackNumbers = []

    $scope.formsValid = false
    $scope.albumEdit = false
    $scope.artistEdit = false
    $scope.producerEdit = false
    $scope.trackEdit = false

    # Register form
    $scope.registerFormScope = (form, id) ->
      $scope.parentForm["childForm" + id] = form

    # Send album JSON to back-end
    $scope.save = () ->
      if $scope.parentForm.$valid
        $scope.formSending = true
        AlbumService.createAlbum($scope.album).then(() ->
          $state.go("root.albums.index", {}, {reload: true})
        )
      $scope.formsValid = $scope.parentForm.$valid

    # Add producer
    $scope.addProducer = () ->
      $scope.album.producers.push({name: "", class_year: "", bio: ""})

    # Remove producer
    $scope.removeProducer = (index, album) ->
      producer = album.producers[index]
      # If producer object already has an id, set destroy flag (handled in back-end) to true
      if producer.id
        producer._destroy = true
      # Otherwise just splice the array
      else
        album.producers.splice(index,1)

    # Add new track to album
    $scope.addTrack = () ->
      $scope.album.tracks.push({artists: [{name: "", class_year: "", bio: ""}], track_number:"", title: "", length_in_seconds: "", file: ""})

    # Remove track from album
    $scope.removeTrack = (index, album) ->
      track = album.tracks[index]
      # If track object already has an id, set destroy flag (handled in back-end) to true
      if track.id
        track._destroy = true
      # Otherwise just splice the array
      else
        album.tracks.splice(index,1)
      console.dir $scope.album

    # Function to check if the current new album has tracks
    $scope.hasTracks = (value) ->
      if value > 0
        return true
      else
        return false

    # Change the value of tracksLength when a new track is added
    $scope.$watch((() -> $scope.album.tracks.length), (newValue)->
      $scope.tracksLength = newValue
    , true)
])

# EDIT an existing album
app.controller("AlbumEditController", ["$scope", "$state", "$stateParams", "AlbumService", "TrackService", "$mdDialog",
  ($scope, $state, $stateParams, AlbumService, TrackService, $mdDialog) ->
    $scope.trackNumbers = []

    # GET album from backend
    AlbumService.getAlbum($stateParams.albumId).then((album) ->
      $scope.album = album
      console.dir $scope.album
    )

    # GET album's producers
    AlbumService.getProducers($stateParams.albumId).then((producers) ->
      $scope.producers = producers
    )

    # GET album's tracks
    AlbumService.getTracks($stateParams.albumId).then((tracks) ->
      $scope.tracks = tracks
      for track in $scope.tracks
        # GET track's artists and albums
        $scope.trackNumbers.push track.track_number
        track.artists = TrackService.getArtists(track.id).$object
        track.album = AlbumService.getAlbum(track.album_id).$object
    )

    $scope.formsValid = false
    $scope.albumEdit = true
    $scope.artistEdit = false
    $scope.producerEdit = false
    $scope.trackEdit = false

    # Function for registering form
    $scope.registerFormScope = (form, id) ->
      $scope.parentForm["childForm" + id] = form

    # Set headers for the track table
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

    # Set initial value for number of tracks to display
    $scope.count=25

    # Add a producer
    $scope.addProducer = () ->
      unless $scope.album.producers
        $scope.album.producers = []
      $scope.album.producers.push({name: "", class_year: "", bio: ""})

    # Remove producer - back end will handle whether to delete it or not
    $scope.removeProducerAssociation = (producer) ->
      producer._remove = true
      unless $scope.album.producers
        $scope.album.producers = []
      $scope.album.producers.push producer

    # Add track
    $scope.addTrack = () ->
      unless $scope.album.tracks
        $scope.album.tracks = []
      $scope.album.tracks.push({artists: [{name: "", class_year: "", bio: ""}], track_number:"", title: "", length_in_seconds: "", file: ""})
      console.dir $scope.album.tracks

    # Remove track
    $scope.removeTrack = (index, album) ->
      track = album.tracks[index]
      if track.id
        track._destroy = true
      else
        album.tracks.splice(index,1)
      console.dir album.tracks

    # Send updated JSON object to backend
    $scope.save = () ->
      $scope.formSending = true
      AlbumService.updateAlbum($scope.album, $stateParams.albumId).then(() ->
        $state.go("root.albums.show", {"albumId": $stateParams.albumId})
      )

    # Open confirm dialog for deletion of an album
    $scope.openDeleteDialog = (e) ->
      $mdDialog.show({
          controller: AlbumDeleteDialogController
          templateUrl: "app/components/mediaContent/album/views/delete-dialog.html"
          parent: angular.element(document.body)
          targetEvent: e
          clickOutsideToClose: true
      }).then(
        (answer) ->
          $scope.delete()
        () ->
      )

    # Send command to delete album to backend
    $scope.delete = () ->
      $scope.formSending = true
      $scope.album.remove().then(() ->
        $state.go("root.albums.index", {}, {reload: true})
      )
])

# Controller for delete dialog
AlbumDeleteDialogController = ["$scope", "$mdDialog", ($scope, $mdDialog) ->
  
  # Dialog completed with an OK
  $scope.hide = () ->
    $mdDialog.hide()

  # Dialog completed with a cancel
  $scope.cancel = () ->
    $mdDialog.cancel()

  # Dialog completed with an input
  $scope.answer = (answer) ->
    $mdDialog.hide(answer)

]

# Set related states for ui-router
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
        # Make sure user is authenticated for this state
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
        # Make sure user is authenticated for this state
        resolve: {
          auth: ["$auth", ($auth) ->
            return $auth.validateUser()
          ]
          producer: ["trackRoles", (trackRoles) ->
            return trackRoles.producer()
          ]
        }
])
