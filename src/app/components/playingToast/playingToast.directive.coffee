angular.module "uTunes"
  .directive 'playingToast', [() ->
    directive =
      restrict: 'E'
      scope: {}
      template: ""
      controller: ($scope, $element, $timeout, $mdToast, $document) ->
        $scope.$on "trackplaying", (e, track) ->
          console.log "A track is playing"
          $mdToast.show({
            controller: ToastController
            templateUrl: "app/components/playingToast/playing-toast.html"
            parent: $document[0].querySelector("playing-toast")
            hideDelay: 0
            locals: {
              trackId: track.id
            }
            position: "bottom right"
          })

  ]

ToastController = ($scope, $mdToast, TrackService, AlbumService, trackId) ->
  TrackService.getTrack(trackId).then((track) ->
    $scope.track = track
    $scope.track.album = AlbumService.getAlbum(track.album_id).$object
    $scope.track.artists = TrackService.getArtists(track.id).$object
    console.dir $scope.track
  )
